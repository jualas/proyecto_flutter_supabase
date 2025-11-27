# Script para probar la API de Resend directamente
# Bypass de Supabase Edge Functions para diagnóstico

Write-Host "🧪 Test directo de Resend API" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Configuración
$ResendApiKey = "RESEND_API_KEY_REMOVED"
$ResendApiUrl = "https://api.resend.com/emails"

# Email de prueba
$ToEmail = "jualas@gmail.com"
$FromEmail = "noreply@fct.jualas.es"
$FromName = "Sistema TFG - CIFP Carlos III"

Write-Host "📋 Configuración:" -ForegroundColor Yellow
Write-Host "  API URL: $ResendApiUrl"
Write-Host "  From: $FromName <$FromEmail>"
Write-Host "  To: $ToEmail"
Write-Host "  API Key: ${ResendApiKey.Substring(0, 10)}..."
Write-Host ""

# Preparar el cuerpo del email
$EmailBody = @{
    from = "$FromName <$FromEmail>"
    to = @($ToEmail)
    subject = "🧪 Test de Resend API - Password Reset"
    html = @"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Test de Email</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
  <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0;">
      <h1 style="margin: 0;">🔒 Test de Resend API</h1>
    </div>
    
    <div style="background: #ffffff; padding: 30px; border-radius: 0 0 8px 8px; border: 1px solid #e0e0e0;">
      <p>Hola,</p>
      
      <p>Este es un email de prueba para verificar que la configuración de Resend está correcta.</p>
      
      <div style="background: #f8f9fa; border: 2px dashed #667eea; border-radius: 8px; padding: 20px; margin: 25px 0; text-align: center;">
        <div style="font-size: 14px; color: #666; margin-bottom: 10px;">CONTRASEÑA DE PRUEBA</div>
        <div style="font-size: 24px; font-weight: bold; color: #667eea; font-family: 'Courier New', monospace; letter-spacing: 2px;">
          Test123!
        </div>
      </div>
      
      <div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 25px 0; border-radius: 4px;">
        <strong style="color: #856404; display: block; margin-bottom: 10px;">⚠️ Información del Test:</strong>
        <ul style="margin: 10px 0; padding-left: 20px; color: #856404;">
          <li>Dominio verificado: fct.jualas.es ✅</li>
          <li>API Key configurada ✅</li>
          <li>SMTP desde Resend ✅</li>
        </ul>
      </div>
      
      <p>Si recibes este email, significa que:</p>
      <ul>
        <li>✅ El dominio fct.jualas.es está correctamente verificado en Resend</li>
        <li>✅ La API Key es válida y funciona</li>
        <li>✅ Los registros DNS (SPF, DKIM) están configurados</li>
      </ul>
      
      <p style="margin-top: 30px; color: #999; font-size: 12px;">
        Sistema de Gestión de Proyectos TFG - CIFP Carlos III<br>
        Este es un email de prueba automático.
      </p>
    </div>
  </div>
</body>
</html>
"@
    text = @"
🔒 TEST DE RESEND API

Hola,

Este es un email de prueba para verificar que la configuración de Resend está correcta.

CONTRASEÑA DE PRUEBA: Test123!

⚠️ INFORMACIÓN DEL TEST:
- Dominio verificado: fct.jualas.es ✅
- API Key configurada ✅
- SMTP desde Resend ✅

Si recibes este email, significa que:
✅ El dominio fct.jualas.es está correctamente verificado en Resend
✅ La API Key es válida y funciona
✅ Los registros DNS (SPF, DKIM) están configurados

---
Sistema de Gestión de Proyectos TFG - CIFP Carlos III
Este es un email de prueba automático.
"@
} | ConvertTo-Json -Depth 10

# Preparar headers
$Headers = @{
    "Authorization" = "Bearer $ResendApiKey"
    "Content-Type" = "application/json"
}

Write-Host "📧 Enviando email de prueba..." -ForegroundColor Yellow
Write-Host ""

try {
    # Realizar la petición
    $Response = Invoke-RestMethod -Uri $ResendApiUrl -Method Post -Headers $Headers -Body $EmailBody -ErrorAction Stop
    
    Write-Host "✅ Email enviado exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Respuesta de Resend:" -ForegroundColor Cyan
    Write-Host "  Email ID: $($Response.id)" -ForegroundColor White
    Write-Host ""
    Write-Host "🔍 Verificación:" -ForegroundColor Yellow
    Write-Host "  1. Revisa la bandeja de entrada de: $ToEmail"
    Write-Host "  2. Si no aparece, revisa la carpeta de SPAM"
    Write-Host "  3. Verifica en Resend Dashboard: https://resend.com/emails"
    Write-Host ""
    Write-Host "✅ Test completado exitosamente" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error al enviar email" -ForegroundColor Red
    Write-Host ""
    Write-Host "📊 Detalles del error:" -ForegroundColor Yellow
    Write-Host "  Mensaje: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        Write-Host "  Respuesta: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "🔍 Posibles causas:" -ForegroundColor Yellow
    Write-Host "  1. API Key incorrecta o expirada"
    Write-Host "  2. Dominio no verificado en Resend"
    Write-Host "  3. Email 'from' no coincide con dominio verificado"
    Write-Host "  4. Problemas de red/firewall"
    Write-Host ""
    Write-Host "📝 Soluciones:" -ForegroundColor Yellow
    Write-Host "  1. Verifica API Key en: https://resend.com/api-keys"
    Write-Host "  2. Verifica dominio en: https://resend.com/domains"
    Write-Host "  3. Verifica que 'from' sea: noreply@fct.jualas.es"
    Write-Host ""
    
    exit 1
}


