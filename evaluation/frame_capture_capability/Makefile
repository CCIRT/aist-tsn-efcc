# Copyright (c) 2025 National Institute of Advanced Industrial Science and Technology (AIST)
# All rights reserved.
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

TARGET = generate_frame.out

all: $(TARGET)

clean:
	rm -f $(TARGET)

%.out: %.cpp
	g++ -O3 -o $@ $^
	# g++ -O0 -g3 -o $@ $^
