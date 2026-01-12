# Guion y Contenido para la Presentación de Defensa del Proyecto

**Título del Proyecto:** Sistema de Seguimiento de Proyectos TFCGS - Ciclo DAM

**Autor:** Juan Antonio Francés Pérez

---

## 1. Introducción y Descripción del Proyecto (2-4 minutos)

### Diapositiva 1: Título

**Título:** Sistema de Seguimiento de Proyectos TFCGS  
**Subtítulo:** Digitalización del ciclo de vida del anteproyecto  
**Autor:** Juan Antonio Francés Pérez  
**Curso:** 2025/2026 - CIFP Carlos III de Cartagena

---

### Diapositiva 2: El Problema y el Origen del Proyecto

**Título:** El Problema: Gestión Manual y Descentralizada

**Origen Personal del Proyecto:**

La idea de desarrollar esta plataforma surgió de mi experiencia personal con este proyecto: cuando me entregaron el modelo de anteproyecto en un documento de Google Drive que tenía que convertir a PDF y devolverlo a mi tutor con todas las características requeridas. Este proceso manual y burocrático me hizo plantearme convertir este proceso en un software que gestionara los anteproyectos de los alumnos de forma eficiente.

**Evolución del Proyecto:**

A partir de esta idea inicial, fui añadiendo funcionalidades según identificaba necesidades adicionales. El proyecto fue creciendo de forma orgánica hasta llegar al estado actual: una plataforma completa que no solo gestiona anteproyectos, sino que también incluye comunicación integrada, gestión de proyectos, tableros Kanban para tareas y un sistema completo de roles.

**El Problema General:**

El proceso actual de gestión de anteproyectos se basa en documentos de Office que deben ser convertidos a PDF, impresos y firmados. Este flujo manual genera burocracia, lentitud y falta de trazabilidad. Los estudiantes trabajan de forma autónoma sin supervisión estructurada, lo que dificulta la validación temprana de sus propuestas por parte del tutor. (Esta parte es algo bucolico he implementable ya que la carga de trabajo que soportan los tutores no les permite realizar seguimientos reales de los poryectos) 

**Resultado:** Pérdida de tiempo, dificultad para el seguimiento y una experiencia deficiente para alumnos y tutores.

---

### Diapositiva 3: La Solución

**Título:** La Solución: Una Plataforma Centralizada y Colaborativa

**Concepto:** Un software que digitaliza todo el ciclo de vida del anteproyecto, desde su creación hasta su aprobación, permitiendo al tutor validar la propuesta antes de que el alumno comience a trabajar.

**Características Principales:**

- **Ciclo de Vida Digital:** Eliminación del papel, gestión 100% digital del anteproyecto.
- **Gestión por Roles:** Interfaces específicas para Estudiantes, Tutores y Administradores.
- **Tecnología Moderna:** Stack tecnológico actual y escalable.

---

### Diapositiva 4: Funcionalidades Clave

**Título:** Funcionalidades Clave

**Puntos clave:**

- **Gestión de Anteproyectos:** Creación, envío y revisión de propuestas de forma 100% digital.
- **Tablero Kanban:** Herramienta visual disponible únicamente cuando el anteproyecto ha sido aprobado y se ha creado el proyecto. Permite al alumno gestionar sus tareas como un checklist de logros mientras trabaja con su IDE favorito. El ciclo de vida de las tareas es opaco al tutor, el alumno es autónomo en el desarrollo.
- **Comunicación Integrada:** Canal directo entre alumno y tutor para comentarios y feedback.

---

## 2. Demostración Funcional (5-7 minutos)

*Esta sección es para la demostración en vivo. El objetivo es mostrar que el proyecto está operativo y cumple con los hitos.*

### Guion de la Demo:

1. **Inicio de Sesión (Login):**
   - Mostrar la pantalla de login.
   - Iniciar sesión primero como **Estudiante**.

2. **Vista del Estudiante:**
   - **Dashboard:** Mostrar el panel principal del estudiante, con un resumen de su proyecto y tareas.
   - **Comunicación con el Tutor:** Destacar que el estudiante puede enviar mensajes y recibir feedback tanto en la fase de anteproyecto como durante el desarrollo del proyecto.
   - **Ver Proyecto y Tareas (Kanban):** Abrir un proyecto existente y mostrar el tablero Kanban. Mover una tarea de "Pendiente" a "En Progreso".
   - Cerrar sesión.

3. **Vista del Tutor:**
   - Iniciar sesión como **Tutor**.
   - **Dashboard del Tutor:** Mostrar la lista de estudiantes y proyectos asignados.
   - **Segmentación:** Destacar que el tutor puede filtrar por años académicos y estados (Pendiente, Aprobado, Rechazado) para una gestión eficiente.
   - **Revisar Anteproyecto:** Navegar a la sección de "Anteproyectos por revisar". Abrir el anteproyecto creado por el estudiante y **aprobarlo**.
   - Explicar que esta acción dispara la creación automática del proyecto.
   - Cerrar sesión.

4. **Vista del Administrador:**
   - Iniciar sesión como **Administrador**.
   - **Gestión de Tutores:** Mostrar que el administrador tiene un rol polivalente, gestionando tutores y resolviendo incidencias.
   - **Control de Infraestructura:** Destacar que tiene acceso directo a los paneles de Supabase (Base de Datos) y Resend (Comunicaciones).
   - **Configuración del Sistema:** Mostrar que puede realizar ajustes globales en la aplicación.

---

## 3. Tecnologías y Arquitectura (2-4 minutos)

### Diapositiva 8: Arquitectura Moderna y Escalable

**Título:** Arquitectura Moderna y Escalable

**Stack Tecnológico:**

| Componente | Tecnología | Justificación de la Elección |
| :--- | :--- | :--- |
| **Frontend** | **Flutter (Dart)** | **Multiplataforma:** Un único código base para Web, Windows y Android. **No trabajamos con iOS**. Rendimiento nativo y desarrollo rápido de UI. |
| **Backend** | **Supabase** | **Backend-as-a-Service de código abierto:** Alternativa a Firebase (con el que trabajamos en el ciclo) que ofrece control total sobre la base de datos PostgreSQL. Incluye seguridad nativa con RLS. |
| **Comunicaciones** | **Resend** | **Email Transaccional:** Integración para el envío de correos desde Supabase, tanto para la gestión del login como para notificaciones de mensajes y comentarios. |
| **Base de Datos** | **PostgreSQL** | **Potencia y fiabilidad:** Un SGBD relacional robusto y escalable, ideal para la estructura de datos del proyecto. |

---

## 4. Aspectos Técnicos 

*Esta sección se presenta de forma general, sin entrar en detalles técnicos profundos.*

### Diapositiva 9: Base de Datos y Seguridad

**Título:** Base de Datos PostgreSQL con Seguridad Integrada

**Qué decir:**

"La base de datos tiene 26 tablas que almacenan toda la información: usuarios, anteproyectos, proyectos, tareas, mensajes, etc. Utiliza PostgreSQL, que es el motor de base de datos que incluye Supabase. El diseño fue iterativo, es decir, fui creando tablas según las necesitaba para cada funcionalidad."

**Sobre la seguridad (RLS):**

"PostgreSQL incluye un sistema de seguridad llamado RLS que protege los datos directamente en la base de datos. Gracias a esto, cada estudiante solo puede ver sus propios proyectos y cada tutor solo ve a sus alumnos asignados. Es una capa de seguridad que funciona independientemente de la aplicación."

**Nota:** Si preguntan detalles técnicos, responder: "El diseño de las tablas fue evolucionando según las necesidades. Las tablas principales son usuarios, anteproyectos, proyectos y tareas, relacionadas entre sí. La seguridad RLS viene incluida en Supabase y se configura mediante políticas."

---

### Diapositiva 10: Organización del Código (Patrón BLoC)

**Título:** Arquitectura del Código: Similar a MVC

**Qué decir:**

"Para organizar el código seguí el patrón BLoC, que es similar al Modelo-Vista-Controlador que vimos en el ciclo. La idea es la misma: separar lo que ve el usuario de la lógica que procesa los datos."

**Comparación simple para explicar:**

| MVC (del ciclo) | BLoC (Flutter) | ¿Qué hace? |
|-----------------|----------------|------------|
| **Vista** | **Widget/UI** | Lo que ve el usuario (pantallas) |
| **Controlador** | **BLoC** | Procesa las acciones y decide qué hacer |
| **Modelo** | **Estado** | Los datos en un momento concreto |

**Beneficios (mencionar brevemente):**
- El código está organizado y es fácil de mantener
- Cada funcionalidad tiene sus propios archivos separados
- Si hay que cambiar algo, es fácil encontrar dónde hacerlo

**Nota:** Si preguntan más detalles sobre BLoC, responder: "Es el patrón que recomienda la comunidad de Flutter. Lo aprendí siguiendo tutoriales y la documentación oficial. Funciona igual que MVC pero adaptado a cómo Flutter gestiona la interfaz."

---

## 5. Hitos y Conclusiones (1-3 minutos)

### Diapositiva 11: Hitos del Anteproyecto - Todos Completados

**Título:** Hitos del Anteproyecto: 100% Completados

**Qué decir:**

"En el anteproyecto definimos 4 hitos principales. Todos han sido completados y en algunos casos superados:"

**Hitos definidos en el Anteproyecto (y su estado):**

| Hito | Descripción | Estado |
|------|-------------|--------|
| **Hito 1** | Análisis, Diseño e Infraestructura Base | ✅ Completado: 26 tablas en PostgreSQL, Supabase configurado |
| **Hito 2** | Autenticación y Gestión de Usuarios | ✅ Completado: JWT, control por roles, acceso limitado a dominio |
| **Hito 3** | Gestión de Anteproyectos, Proyectos y Tareas | ✅ Completado: Ciclo completo anteproyecto→proyecto, vista Kanban funcional |
| **Hito 4** | Funcionalidades Colaborativas | ✅ Completado: Comentarios, mensajes, notificaciones por email |

**Nota:** Destacar que el proyecto no solo cumple los hitos definidos, sino que los supera con funcionalidades adicionales como el sistema de comunicación bidireccional y la gestión completa del ciclo de vida del anteproyecto.

---

### Diapositiva 12: Desafíos Superados y Aprendizajes

**Título:** Desafíos Superados y Aprendizajes

**Tecnologías Nuevas (no vistas en el ciclo):**

- **Flutter:** Framework multiplataforma para el frontend. No se cubrió en el ciclo, aprendido de forma autodidacta.
- **Supabase:** Framework BaaS (Backend as a Service) con PostgreSQL. En el ciclo no trabajamos con frameworks para backend ni para la persistencia de datos de forma estructurada.
- **Docker:** Contenedorización para el servidor web y despliegue en producción.
- **Git y GitHub:** Control de versiones con repositorio local y remoto. Gestión de ramas (branches) para desarrollo organizado: rama principal (main), ramas de desarrollo y features.

**Qué decir sobre Git:**

"Utilicé Git para el control de versiones, tanto en local como con repositorio remoto en GitHub. Trabajé con el concepto de ramas: una rama principal (main) para el código estable y ramas separadas para desarrollar nuevas funcionalidades antes de integrarlas."

---

### Diapositiva 13: Próximos Pasos y Mejoras

**Título:** Líneas de Trabajo Futuras

**Mejoras Planificadas:**

- **Generación de PDF con Firma Digital:** Convertir el anteproyecto aprobado a PDF y permitir que tanto el tutor como el alumno lo firmen digitalmente. El documento quedaría guardado con ambas firmas, eliminando completamente el proceso en papel.
- **Asistente IA (MCP + LLM):** Implementación de un servidor MCP para conectar con LLMs y ofrecer recomendaciones inteligentes a los alumnos en sus tareas.
- **Login Institucional:** Integración futura con el sistema de autenticación SSO de murciaeduca.es para un acceso unificado.

---

### Diapositiva 14: Conclusiones Finales

**Título:** Conclusiones Finales

**Objetivo Cumplido:**

Hemos logrado digitalizar y optimizar el ciclo de vida del anteproyecto, eliminando la burocracia del papel y empoderando al alumno con autonomía supervisada.

**Stack Tecnológico:**

Dominio demostrado de tecnologías modernas como **Flutter**, **Supabase**, **Docker** y **Resend**, superando las expectativas del ciclo formativo.

**Producto Real:**

Entregamos una aplicación funcional, segura y desplegable, lista para ser utilizada en un entorno educativo real.

---

### Diapositiva 15: ¡Gracias!

**Título:** Preguntas y Debate

**Autor:** Juan Antonio Francés Pérez  
**Contacto:** jualas@jualas.es  
**Repositorio:** github.com/elmosca/proyecto_flutter_supabase

---

## Notas Adicionales para la Defensa

### Puntos a Enfatizar:

1. **Digitalización del Anteproyecto:** Hacer hincapié en que nuestro proyecto da solución a la manera en que hay que presentar el anteproyecto, que es la primera fase de trabajo para que el tutor valide y se pueda empezar a trabajar y desarrollar el proyecto. En el ciclo de vida real y actual, el alumno trabaja de forma autónoma sin supervisión, tal como hemos implementado nosotros en nuestra aplicación.

2. **Tareas como Checklist:** Las tareas se convierten en un guion de trabajo que el alumno puede utilizar para marcar como check de logros mientras trabaja con su IDE de desarrollo favorito. Por eso, la parte de proyecto y el ciclo de vida de las tareas se convierte en opaco al tutor; el alumno es autónomo en el desarrollo del mismo.

3. **Multiplataforma sin iOS:** En el punto 8, aclarar que la multiplataforma no trabajamos con iOS, pero sí con el resto de salidas soportadas por Flutter.

4. **Diapositivas 9 y 10 - Explicación Simplificada:** Estas dos diapositivas técnicas se explican de forma general. Si preguntan detalles:
   - **Base de Datos y Seguridad (Diap. 9):** "La base de datos tiene 26 tablas con diseño iterativo. La seguridad RLS viene incluida en Supabase y garantiza que cada usuario solo vea sus datos."
   - **Organización del código (Diap. 10):** "Seguí el patrón BLoC, similar a MVC: separar pantallas, lógica y datos."

5. **Autenticación Limitada:** En la diapositiva 11 (Hitos), aclarar que hemos limitado la autenticación con el correo electrónico de un dominio concreto, ya que es una aplicación para un centro de educación enfocado a unos usuarios concretos (no es una aplicación abierta).

6. **Conclusiones:** En la diapositiva 14, enfocarse en los logros y el producto entregado.
