function __os
    set arch 
    set bsd 
    set linux 
    set mac 
    set raspbian 
    set ubuntu 
    set known_glyphs arch bsd linux mac raspbian ubuntu
    set unknown_glyph 

    switch (uname)
    case Linux
        set _os (string lower (cat /etc/issue | cut -d' ' -f1))[1]
    case Darwin
        set _os mac
    case '*'
        set _os other
    end
    if test -z $argv[1]
        printf "%s" $_os
        return
    end
    if string match -q 'glyph' $argv[1]
        if contains $_os $known_glyphs
            printf "%s " $$_os
        else
            printf "%s " $_unknown_glyph
        end
    end
end

