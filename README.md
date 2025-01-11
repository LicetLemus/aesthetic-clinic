# AestheticControl

## Descripción

Este proyecto consiste en desarrollar una aplicación en Salesforce para la gestión de procedimientos estéticos en una clínica. La aplicación controla los datos de los clientes, gestiona las reservas de citas, y permite registrar los procedimientos realizados, entre otros. La solución incluye un modelo de datos personalizado, una serie de procesos automatizados con Apex y LWC, y una interfaz amigable para los usuarios.

## Objetivo

El objetivo del reto es demostrar el conocimiento técnico y las habilidades en la plataforma Salesforce, creando una aplicación funcional para la gestión de una clínica estética. La aplicación cubre desde el control de clientes hasta la automatización de tareas relacionadas con las citas y procedimientos.

## Solución Técnica

### Modelo de Datos

- **Contacto**: 
  - Campos estándar como Nombre, Teléfono, Fecha de nacimiento, Correo electrónico, y Edad (campo fórmula).
  - Relaciones con otros objetos como "Reporta a" para la persona responsable.

- **Reservas**:
  - Identificación numérica generada automáticamente.
  - Relación con el objeto Contacto y campos como Estado, Fecha, Duración y Valor total.

- **Ítem de la programación**:
  - Relacionado con la Reserva, Procedimiento (Product2), y Profesional (Usuario).
  - Campos como Duración, Valor y Estado.

- **Producto2 (Procedimiento)**:
  - Campos estándar como Nombre, ProductCode, Valor (moneda) y Duración (minutos).

## Características Clave

- **Gestión de Contactos**: Registro completo de información de los clientes, incluyendo datos personales, edad calculada automáticamente.
- **Gestión de Reservas**: Citas gestionadas con estados y fechas, validación de edad y tutor para menores de edad.
- **Automatización de Procesos**: Uso de procesos en Apex para la aprobación de procedimientos, cancelación de citas no completadas y generación automática de comisiones.
- **Interfaz Amigable**: Páginas Lightning y componentes LWC organizados de manera intuitiva para facilitar la navegación y el uso del sistema.
- **Notificaciones Automáticas**: Envío de correos electrónicos automáticos a los clientes al realizar cambios en el estado de las citas.

## Tecnologías Utilizadas

- **Salesforce**: Apex, Lightning Web Components (LWC), Visualforce
- **Herramientas**: Git, GitHub