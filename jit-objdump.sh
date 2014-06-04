#!/bin/bash

_last=${@: -1}

#['--start-address=0x00007f75752be6e0', '--stop-address=0x00007f75752bf1e0', '-d', '--no-show-raw', '-S', '-C', '/tmp/perf-21470.map']

if [[ $_last =~ /tmp/perf- ]]; then
	_start=$(echo $1 | sed "s/--start-address=//")
	_stop=$(echo $2 | sed "s/--stop-address=//")
	pid=$(echo $_last | sed -e "s/.map//" -e "s@/tmp/perf-@@")
	tmp=$(mktemp)
	gdb --batch --pid $pid -ex "dump memory $tmp $_start $_stop" &> /tmp/gdb.log && \
	objdump --adjust-vma=$_start  -D -b binary -mi386:x86-64 $tmp;
	rm $tmp;
else
	objdump $*
fi
