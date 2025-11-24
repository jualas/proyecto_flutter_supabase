# Script para probar la Edge Function reset-password
# Ejecutar desde PowerShell: .\scripts\test-reset-password-edge-function.ps1

# Configuración de tu proyecto Supabase
$supabaseUrl = "https://zkririyknhlwoxhsoqih.supabase.co"
$anonKey = "SUPABASE_JWT_REMOVED"

# ⚠️ CAMBIA ESTOS VALORES:
$userEmail = "juanantonio.frances.perez@gmail.com"  # Email del estudiante a resetear
$newPassword = "NuevaPassword123!"              # Nueva contraseña

Write-Host "🧪 Probando Edge Function reset-password..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuración:" -ForegroundColor Yellow
Write-Host "  URL: $supabaseUrl" -ForegroundColor Gray
Write-Host "  Email: $userEmail" -ForegroundColor Gray
Write-Host "  Nueva contraseña: $newPassword" -ForegroundColor Gray
Write-Host ""

# Preparar el body
$body = @{
    user_email = $userEmail
    new_password = $newPassword
} | ConvertTo-Json -Compress

# Headers
$headers = @{
    "Authorization" = "Bearer $anonKey"
    "apikey" = $anonKey
    "Content-Type" = "application/json"
}

# URL completa
$endpointUrl = "$supabaseUrl/functions/v1/super-action"

Write-Host "📡 Enviando petición a: $endpointUrl" -ForegroundColor Cyan
Write-Host ""

# Hacer la petición
try {
    $response = Invoke-RestMethod -Uri $endpointUrl `
        -Method Post `
        -Headers $headers `
        -Body $body `
        -ErrorAction Stop
    
    Write-Host "✅ ÉXITO - Respuesta recibida:" -ForegroundColor Green
    Write-Host ""
    $response | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor Green
    
    if ($response.success -eq $true) {
        Write-Host ""
        Write-Host "🎉 La contraseña se ha actualizado correctamente!" -ForegroundColor Green
        Write-Host "   El estudiante $userEmail ahora puede iniciar sesión con la nueva contraseña." -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ ERROR - No se pudo resetear la contraseña:" -ForegroundColor Red
    Write-Host ""
    
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "   Código de estado: $statusCode" -ForegroundColor Yellow
        
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "   Respuesta del servidor:" -ForegroundColor Yellow
            Write-Host "   $responseBody" -ForegroundColor Red
        } catch {
            Write-Host "   No se pudo leer la respuesta del servidor" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   Mensaje: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "💡 Posibles causas:" -ForegroundColor Yellow
    Write-Host "   1. La Edge Function no está desplegada" -ForegroundColor Gray
    Write-Host "   2. El email del estudiante no existe en auth.users" -ForegroundColor Gray
    Write-Host "   3. Problema de conectividad" -ForegroundColor Gray
    Write-Host "   4. La anon key no es correcta" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   Revisa: docs/desarrollo/probar_edge_function_reset_password.md" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

