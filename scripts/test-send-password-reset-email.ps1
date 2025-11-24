# Script para probar el envío de email de password reset
# usando la Edge Function super-action

$SUPABASE_URL = "https://zkririyknhlwoxhsoqih.supabase.co"
$SUPABASE_ANON_KEY = "SUPABASE_JWT_REMOVED"

Write-Host "🧪 Probando envío de email de password reset..." -ForegroundColor Cyan
Write-Host ""

# Datos de prueba
$body = @{
    action = "send_password_reset_email"
    user_email = "lamoscaproton@gmail.com"
    new_password = "TestPass123!"
    user_data = @{
        student_name = "El Mosca"
        student_email = "lamoscaproton@gmail.com"
        reset_by = "Tutor"
        reset_by_name = "Tutor Jualas"
    }
} | ConvertTo-Json -Depth 10

Write-Host "📧 Enviando solicitud a Edge Function..." -ForegroundColor Yellow
Write-Host "URL: $SUPABASE_URL/functions/v1/super-action"
Write-Host "Email: lamoscaproton@gmail.com"
Write-Host ""

try {
    $response = Invoke-RestMethod `
        -Uri "$SUPABASE_URL/functions/v1/super-action" `
        -Method Post `
        -Headers @{
            "Authorization" = "Bearer $SUPABASE_ANON_KEY"
            "Content-Type" = "application/json"
            "apikey" = $SUPABASE_ANON_KEY
        } `
        -Body $body `
        -TimeoutSec 30

    Write-Host "✅ Respuesta recibida:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10 | Write-Host
    Write-Host ""

    if ($response.success -eq $true) {
        Write-Host "🎉 ¡Email enviado exitosamente!" -ForegroundColor Green
        Write-Host "📬 Revisa la bandeja de entrada de: lamoscaproton@gmail.com" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "⚠️ NOTA: Si no llega el email:" -ForegroundColor Yellow
        Write-Host "1. Revisa los logs de Edge Function en Supabase Dashboard"
        Write-Host "2. Verifica que el template 'Magic Link' esté configurado"
        Write-Host "3. Revisa la carpeta de spam"
    } else {
        Write-Host "❌ Error en la respuesta:" -ForegroundColor Red
        $response | ConvertTo-Json -Depth 10 | Write-Host
    }
} catch {
    Write-Host "❌ Error al llamar Edge Function:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Posibles causas:" -ForegroundColor Yellow
    Write-Host "1. La Edge Function no está desplegada"
    Write-Host "2. La acción 'send_password_reset_email' no está implementada"
    Write-Host "3. Problema de red o CORS"
    Write-Host ""
    Write-Host "🔧 Solución:" -ForegroundColor Cyan
    Write-Host "1. Ve a Supabase Dashboard → Edge Functions → super-action"
    Write-Host "2. Verifica que el código esté actualizado"
    Write-Host "3. Revisa los logs para más detalles"
}

Write-Host ""
Write-Host "📊 Para ver los logs en Supabase:" -ForegroundColor Cyan
Write-Host "Dashboard → Edge Functions → super-action → Logs"

