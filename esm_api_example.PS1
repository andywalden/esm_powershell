cls
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$esmhost = 'https://<ESM-IP>/rs/esm/'
$username = 'NGCP'
$passwd = 'SupaSecret'
$login_url = $esmhost + "login"

$v10_b64_user = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username))
$v10_b64_passwd = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($passwd))

$v10_params = @{
        username = $v10_b64_user
        password = $v10_b64_passwd
        locale = 'en_US'
        os = 'Win32'};        
$body = $v10_params | ConvertTo-Json

$headers = @{
    'Content-Type' = 'application/json'
    };

$login_headers = $headers
$login_headers.Add("Authorization", "Basic "+[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$passwd )))
$response = Invoke-WebRequest $login_url -Method Post -Headers $login_headers -Body $body -SessionVariable Cookie

$headers.Add('X-Xsrf-Token', $response.headers.Get_Item('Xsrf-Token'))

$method = 'essmgtGetESSTime'
$url = $esmhost + $method
$response = Invoke-WebRequest $url -Method Post -Headers $headers -WebSession $Cookie

