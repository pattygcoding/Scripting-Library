function clear-git {
    git branch -vv | 
        Where-Object { 
            $_ -notmatch '\[origin/' 
        } | 
        ForEach-Object { 
            ($_ -split '\s+')[1] 
        } | 
        ForEach-Object { 
            git branch -D $_ 
        }  
}
