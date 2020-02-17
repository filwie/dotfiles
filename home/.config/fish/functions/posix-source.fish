function posix-source
    if test (count $argv) -ne 1; or not test -f $argv[1]
        return 1
    end

	for i in (cat $argv)
        if test -z $i
            continue
        end
		set arr (echo $i |tr = \n)
        set -gx $arr[1] $arr[2]
	end
end
