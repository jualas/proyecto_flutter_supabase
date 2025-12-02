# Script para reemplazar Service Role Key en archivos
$serviceKey = "SUPABASE_JWT_REMOVED"
$replacement = "REMOVIDO_POR_SEGURIDAD"

Get-ChildItem -Recurse -File -Include *.ps1,*.js,*.ts,*.dart,*.md,*.txt,*.env -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -and $content -match [regex]::Escape($serviceKey)) {
            $newContent = $content -replace [regex]::Escape($serviceKey), $replacement
            Set-Content $_.FullName -Value $newContent -NoNewline -ErrorAction SilentlyContinue
        }
    } catch {
        # Ignorar errores
    }
}

