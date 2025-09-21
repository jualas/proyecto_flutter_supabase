const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'http://127.0.0.1:54321';
const SUPABASE_SERVICE_KEY = 'SUPABASE_JWT_REMOVED';

async function testConnection() {
  try {
    console.log('🔧 Probando conexión con Supabase Local...');
    console.log('URL:', SUPABASE_URL);
    
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);
    
    // Probar conexión básica
    const { data, error } = await supabase.from('users').select('count').limit(1);
    
    if (error) {
      console.log('❌ Error de conexión:', error.message);
      return;
    }
    
    console.log('✅ Conexión exitosa con Supabase Local');
    console.log('📊 Respuesta:', data);
    
    // Probar listar usuarios
    const { data: users, error: usersError } = await supabase.from('users').select('*').limit(5);
    
    if (usersError) {
      console.log('❌ Error listando usuarios:', usersError.message);
    } else {
      console.log('👥 Usuarios encontrados:', users.length);
      users.forEach(user => {
        console.log(`  - ${user.email} (${user.role})`);
      });
    }
    
  } catch (error) {
    console.log('❌ Error de conexión:', error.message);
  }
}

testConnection();
