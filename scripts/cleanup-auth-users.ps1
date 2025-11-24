# Script rápido para eliminar usuarios de auth.users fuera del dominio jualas.es
# Requiere: Service Role Key de Supabase

param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceRoleKey
)

$SupabaseUrl = "https://zkririyknhlwoxhsoqih.supabase.co"
$AnonKey = "SUPABASE_JWT_REMOVED"

Write-Host "🔐 Eliminando usuarios de auth.users fuera del dominio jualas.es..." -ForegroundColor Yellow
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $ServiceRoleKey"
    "Content-Type" = "application/json"
    "apikey" = $AnonKey
}

$body = @{
    action = "bulk_delete_users_by_domain"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$SupabaseUrl/functions/v1/super-action" `
        -Method Post `
        -Headers $headers `
        -Body $body `
        -ErrorAction Stop

    Write-Host "✅ Limpieza de auth.users completada:" -ForegroundColor Green
    Write-Host "   Total encontrados: $($response.summary.total_found)" -ForegroundColor White
    Write-Host "   Eliminados: $($response.summary.deleted)" -ForegroundColor Green
    Write-Host "   Errores: $($response.summary.errors)" -ForegroundColor $(if ($response.summary.errors -gt 0) { "Red" } else { "Green" })
    Write-Host ""
    
    if ($response.deleted_users.Count -gt 0) {
        Write-Host "📋 Usuarios eliminados:" -ForegroundColor Yellow
        foreach ($user in $response.deleted_users) {
            Write-Host "   ✅ $($user.email)" -ForegroundColor Green
        }
    }
    
    if ($response.errors.Count -gt 0) {
        Write-Host ""
        Write-Host "❌ Errores:" -ForegroundColor Red
        foreach ($error in $response.errors) {
            Write-Host "   ❌ $($error.email): $($error.error)" -ForegroundColor Red
        }
    }
    
} catch {
    Write-Host "❌ Error al eliminar usuarios de auth.users:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "   Detalles: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    exit 1
}

