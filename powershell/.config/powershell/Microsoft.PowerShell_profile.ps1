oh-my-posh init pwsh | Invoke-Expression

$ohMyPoshPath = brew --prefix oh-my-posh
oh-my-posh --init --shell pwsh --config $ohMyPoshPath + "/themes/uew.omp.json" | Invoke-Expression
