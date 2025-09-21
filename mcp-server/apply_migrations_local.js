import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';

const SUPABASE_URL = 'http://127.0.0.1:54321';
const SUPABASE_SERVICE_KEY = 'SUPABASE_JWT_REMOVED';

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

// Lista de migraciones en orden
const migrations = [
  '20240815000001_create_initial_schema.sql',
  '20240815000002_create_triggers_and_functions.sql',
  '20240815000003_seed_initial_data.sql',
  '20240815000004_configure_rls_fixed.sql',
  '20240815000005_configure_auth.sql'
];

async function applyMigrations() {
  console.log('🚀 Aplicando migraciones a Supabase Local...\n');

  for (const migration of migrations) {
    const migrationPath = path.join('../backend/supabase/migrations', migration);
    
    try {
      console.log(`📄 Aplicando migración: ${migration}`);
      
      // Leer el archivo de migración
      const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
      
      // Ejecutar la migración usando RPC
      const { data, error } = await supabase.rpc('exec_sql', {
        sql: migrationSQL
      });

      if (error) {
        console.error(`❌ Error en migración ${migration}:`, error);
        // Continuar con la siguiente migración
      } else {
        console.log(`✅ Migración ${migration} aplicada correctamente`);
      }
      
    } catch (e) {
      console.error(`❌ Error leyendo migración ${migration}:`, e.message);
    }
  }

  console.log('\n🎉 Proceso de migración completado!');
  console.log('📋 Verificando tablas creadas...');
  
  // Verificar que las tablas se crearon
  try {
    const { data: tables, error } = await supabase
      .from('information_schema.tables')
      .select('table_name')
      .eq('table_schema', 'public');
    
    if (error) {
      console.error('❌ Error verificando tablas:', error);
    } else {
      console.log('📊 Tablas encontradas:');
      tables.forEach(table => {
        console.log(`  - ${table.table_name}`);
      });
    }
  } catch (e) {
    console.error('❌ Error verificando tablas:', e.message);
  }
}

applyMigrations();
