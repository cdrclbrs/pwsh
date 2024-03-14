$command = @"
\$Host.UI.RawUI.BackgroundColor = "Black"
\Host.UI.RawUI.ForegroundColor = "Green"
Clear-Host
Write-Host 'Ne laissez pas votre ordinateur non verouillé!
███████████████████████████
███████▀▀▀░░░░░░░▀▀▀███████
████▀░░░░░░░░░░░░░░░░░▀████
███│░░░░░░░░░░░░░░░░░░░│███
██▌│░░░░░░░░░░░░░░░░░░░│▐██
██░└┐░░░░░░░░░░░░░░░░░┌┘░██
██░░└┐░░░░░░░░░░░░░░░┌┘░░██
██░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░██
██▌░│██████▌░░░▐██████│░▐██
███░│▐███▀▀░░▄░░▀▀███▌│░███
██▀─┘░░░░░░░▐█▌░░░░░░░└─▀██
██▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄██
████▄─┘██▌░░░░░░░▐██└─▄████
█████░░▐█─┬┬┬┬┬┬┬─█▌░░█████
████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐████
█████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████
███████▄░░░░░░░░░░░▄███████
██████████▄▄▄▄▄▄▄██████████
███████████████████████████

1- Verrouillage de l ordinateur : Sécurisez l'accès avec un mot de passe ou une authentification biométrique.
2- VPN : Chiffrez votre connexion avec un VPN.
3- Authentification à deux facteurs : Renforcez la sécurité des comptes avec le 2FA.
4- Mises à jour : Assurez-vous que vos logiciels sont à jour.
5- Prudence : Employez un antivol physique et soyez vigilant contre l ingénierie sociale.
'
"@

$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
Start-Process powershell -ArgumentList "-NoExit", "-EncodedCommand", $encodedCommand

