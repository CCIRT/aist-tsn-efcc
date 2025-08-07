// Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
// All rights reserved.
// This software is released under the MIT License.
// http://opensource.org/licenses/mit-license.php

#include <arpa/inet.h>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fcntl.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <net/if.h>
#include <net/ethernet.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <vector>

struct EthHeader {
  uint8_t dst_mac[6] = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55};
  uint8_t src_mac[6] = {0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
  uint16_t type = htons(0x0800);
};

struct IpHeader {
  uint8_t version_ihl = 0x45;
  uint8_t dscp_ecn = 0;
  uint16_t total_length = 0;
  uint16_t identification = 0;
  uint16_t fragment = htons(0x4000);
  uint8_t ttl = 255;
  uint8_t protocol = 17; // UDP
  uint16_t checksum = 0;
  uint32_t src = htonl(0xc0a80010);
  uint32_t dst = htonl(0xc0a80120);

  IpHeader& update_length(std::size_t l2_length) {
    total_length = htons(l2_length - sizeof(EthHeader));
    return *this;
  }

  IpHeader& update_checksum() {
    uint16_t* ptr = reinterpret_cast<uint16_t*>(this);
    uint32_t csum = 0;
    for (uint32_t i = 0; i < sizeof(IpHeader); i += 2) {
      csum += *ptr++;
    }
    csum = (csum & 0xffff) + (csum >> 16);
    csum = (csum & 0xffff) + (csum >> 16);
    checksum = ~csum;

    return *this;
  }
};

struct UdpHeader {
  uint16_t src_port = htons(1245);
  uint16_t dst_port = htons(4567);
  uint16_t length;
  uint16_t checksum = 0;

  UdpHeader& update_length(std::size_t l2_length) {
    length = htons(l2_length - sizeof(EthHeader) - sizeof(IpHeader));
    return *this;
  }
};

struct MagicWord {
  uint8_t magic_word[10] = {'A', 'I', 'S', 'T', 'S', 'N', 'E', 'F', 'C', 'C'};
};

using TimestampId = uint32_t;

class Frame {
public:
  Frame() = default;
  ~Frame() = default;

  template <typename T>
  void push(const T& val) {
    auto prev_size = buf_.size();
    buf_.resize(prev_size + sizeof(val));
    auto ptr = buf_.data() + prev_size;
    std::memcpy(ptr, &val, sizeof(val));
  }

  void resize(std::size_t size) {
    buf_.resize(size);
  }

  uint8_t* data() {
    return buf_.data();
  }

  std::size_t size() {
    return buf_.size();
  }

private:
  std::vector<uint8_t> buf_;
};


int main(int argc, char* argv[]) {
  if (argc != 4) {
    printf("%s <netif> <l2_length> <NUM>\n", argv[0]);
    return -1;
  }

  const char* dev_name = argv[1];
  uint32_t l2_length = std::strtoul(argv[2], nullptr, 0);
  uint32_t num = std::strtoul(argv[3], nullptr, 0);

  // construct Frame
  Frame frame;
  frame.push(EthHeader{});
  frame.push(IpHeader{}.update_length(l2_length).update_checksum());
  frame.push(UdpHeader{}.update_length(l2_length));
  frame.push(MagicWord{});
  frame.push(TimestampId{0});
  frame.resize(l2_length);

  printf("frame content: \n");
  for (uint32_t i = 0; i < frame.size(); i++) {
    printf("%02x", frame.data()[i]);
  }
  printf("\n");

  // open socket
  int sock = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_IP));
  if (sock < 0) {
    printf("sock failed\n");
    return -1;
  }

  // set non blocking
  int current = fcntl(sock, F_GETFL, 0);
  fcntl(sock, F_SETFL, current | O_NONBLOCK);

  // int one = 1;
  // if (setsockopt(sock, SOL_SOCKET, SO_ZEROCOPY, &one, sizeof(one))) {
  //   printf("setsockopt failed\n");
  //   return -1;
  // }

  // bind device
  struct sockaddr_ll addr{};
  addr.sll_family = AF_PACKET;
  addr.sll_ifindex = if_nametoindex(dev_name);
  addr.sll_protocol = htons(ETH_P_IP);

  if (bind(sock, (struct sockaddr*) &addr, sizeof(addr)) < 0) {
    printf("bind failed\n");
    return -1;
  }

  // main loop
  uint8_t* p_frame = frame.data();
  std::size_t frame_size = frame.size();

  // may be unaligned, but x86 can do this.
  std::vector<std::chrono::steady_clock::time_point> ts(num);
  uint32_t* p_tid = reinterpret_cast<uint32_t*>(p_frame + sizeof(EthHeader) + sizeof(IpHeader) + sizeof(UdpHeader) + sizeof(MagicWord));
  for (uint32_t i = 0; i < num; i++) {
    *p_tid = i;

    ts[i] = std::chrono::steady_clock::now();
    auto len = send(sock, p_frame, frame_size, 0);;
    while (len != frame_size) {
      len = send(sock, p_frame, frame_size, 0);
    }
  }

  // for (uint32_t i = 1; i < num; i++) {
  //   printf("delta[%u]: %lu ns\n", i, std::chrono::duration_cast<std::chrono::nanoseconds>(ts[i] - ts[i-1]).count());
  // }
}
