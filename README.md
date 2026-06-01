# Sistema de Gestión de Reservas Turísticas ✈️

Este repositorio contiene el script de base de datos relacional para la gestión integral de un comercio turístico, abarcando desde la administración de propiedades hasta el procesamiento de reservas, pagos y auditoría de usuarios.

---

## ⚙️ Motor de Base de Datos
* **Motor Usado:** PostgreSQL
* **Versión Base:** 18.4

---

## 🗺️ Esquema de la Base de Datos (`tourism`)

La base de datos se organiza bajo un único esquema llamado **`tourism`** y está distribuida en los siguientes módulos relacionales:

### 👤 Usuarios y Actores
* **`owners`**: Información de los propietarios de los alojamientos (datos de contacto y fiscales).
* **`guests`**: Registro de clientes o huéspedes principales que contratan los servicios.
* **`booking_guests`**: Registro de acompañantes o invitados asociados a una estancia.
* **`staff_users`**: Personal administrativo con roles asignados (*Admin, Manager, Receptionist, Accountant*).

### 🏨 Catálogo de Alojamientos
* **`accommodations`**: Cabecera de propiedades en alquiler (precios base por noche, políticas de horarios y capacidad).
* **`accommodation_types`**: Categorías de hospedaje (*Hotel, Hostel, Apartment, Villa, Cabin, etc.*).
* **`rooms`**: Habitaciones específicas por alojamiento (capacidad, número de camas y precio por noche).
* **`amenities`**: Catálogo general de servicios (*WiFi, Pool, Parking, Breakfast, etc.*).
* **`accommodation_amenities`**: Tabla intermedia que conecta los alojamientos con sus respectivos servicios.

### 📅 Transacciones y Feedback
* **`bookings`**: El núcleo del negocio; registra fechas de estancia, conteo de huéspedes, desglose de montos y noches totales calculadas.
* **`booking_statuses`**: Estados del ciclo de vida de la reserva (*Pending, Confirmed, CheckedIn, CheckedOut, Cancelled, NoShow*).
* **`payments`**: Transacciones financieras asociadas (métodos de pago, referencias bancarias y estados de cobro).
* **`reviews`**: Puntuaciones del 1 al 5 y reseñas escritas dejadas por los huéspedes tras su salida.

### 📍 Datos Geográficos
* **`locations`**: Direcciones físicas detalladas, códigos postales y coordenadas geográficas (*Latitud / Longitud*) de cada propiedad.
