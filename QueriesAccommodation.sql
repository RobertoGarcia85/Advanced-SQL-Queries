--CONSULTAS SQL--
--LIC. ROBERTO ANTONIO GARCIA--
--INSTITUTO NACIONAL DE JUCUAPA--

-- C1: Descripción: Agregar un nuevo propietario a la tabla
select * from tourism.owners;
INSERT INTO tourism.owners (
    first_name, 
    last_name, 
    company_name, 
    email, 
    phone, 
    tax_id, 
    address_line1, 
	address_line2,
    city, 
    state, 
    country, 
    postal_code
) VALUES (
    'Roberto', 
    'García', 
    'PCFIX SM', 
    'pcfixsm@gmail.com', 
    '+50375121466', 
    'SV-B12345678', 
    'Barrio la Merced', 
	'Cerca del mercadito San Nicolas',
    'San Miguel', 
    'San Miguel centro', 
    'El Salvador', 
    'CP3301'
);

-- C2: Insertar un nuevo alojamiento.
select * from tourism.accommodations;
INSERT INTO tourism.accommodations (
    owner_id, 
    accommodation_type_id, 
    location_id, 
    name, 
    description, 
    max_guests, 
    bedroom_count, 
    bathroom_count, 
    base_price_per_night, 
    currency_code, 
    is_active
) VALUES (
    22,          
    3,         
    5,          
    'Apartamento Vista Marina Premium', 
    'Espectacular apartamento con terraza privada y acceso directo a la playa.', 
    4, 
    2, 
    2, 
    145.50, 
    'USD',  
    true
);

-- C3: INSERT: Huésped y reserva - Registrar huésped y reserva.
WITH nuevo_huesped AS (
    INSERT INTO tourism.guests (
        first_name, 
        last_name, 
        email, 
        phone, 
        date_of_birth, 
        nationality, 
        passport_number
    ) VALUES (
        'Jacob', 
        'Fernández', 
        'jfernandez2000@gmail.com', 
        '+50375121466', 
        '2000-05-14', 
        'Barcelona', 
        'BARG987654'
    )
    RETURNING guest_id
)
INSERT INTO tourism.bookings (
    guest_id, 
    accommodation_id, 
    room_id, 
    booking_status_id, 
    check_in_date, 
    check_out_date, 
    adult_count, 
    child_count, 
    subtotal_amount, 
    tax_amount, 
    discount_amount, 
    total_amount, 
    booking_reference
)
SELECT 
    guest_id, 
    1,             -- ID del alojamiento elegido
    NULL,          -- ID de habitación específica (si aplica al hotel)
    1,             -- ID de Estado (1 = Pending)
    '2026-07-10',  -- check_in_date
    '2026-07-15',  -- check_out_date
    2,             -- adult_count
    0,             -- child_count
    727.50,        -- subtotal_amount
    87.30,         -- tax_amount
    0.00,          -- discount_amount
    814.80,        -- total_amount
    'BK-2026LG77'  -- booking_reference (Único)
FROM nuevo_huesped;

-- C4 INSERT	Insertar pago
INSERT INTO tourism.payments (
    booking_id, 
    amount, 
    payment_method, 
    payment_status, 
    transaction_reference, 
    notes
) VALUES (
    1,                        
    814.80, 
    'CreditCard', 
    'Completed', 
    'TXN-99238411-XYZ', 
    'Pago total de la estancia procesado con pasarela bancaria.'
);

-- C5: alojamientos activos
SELECT 
    a.accommodation_id, 
    a.name, 
    t.type_name AS tipo, 
    a.base_price_per_night AS precio_base, 
    a.currency_code AS moneda, 
    a.max_guests AS capacidad_maxima
FROM tourism.accommodations a
INNER JOIN tourism.accommodation_types t 
    ON a.accommodation_type_id = t.accommodation_type_id
WHERE a.is_active = true
ORDER BY a.base_price_per_night DESC;

-- C6: Huéspedes por país
SELECT 
    guest_id, 
    first_name AS nombre, 
    last_name AS apellido, 
    email, 
    nationality AS nacionalidad, 
    passport_number AS pasaporte
FROM tourism.guests
WHERE nationality = 'Barcelona'
ORDER BY last_name ASC, first_name ASC;

-- C7: Reservas por fechas
SELECT 
    booking_id, 
    booking_reference AS referencia, 
    check_in_date AS fecha_ingreso, 
    check_out_date AS fecha_salida, 
    total_amount AS monto_total
FROM tourism.bookings
WHERE check_in_date BETWEEN '2025-06-01' AND '2025-06-30'
ORDER BY check_in_date ASC;

-- C8: Actualizar precio
UPDATE tourism.accommodations
SET base_price_per_night = 160.00
WHERE accommodation_id = 1;

--C9: Actualizar estado de reserva
UPDATE tourism.bookings
SET booking_status_id = 2  
WHERE booking_id = 1;

-- C10: Eliminar reseña
DELETE FROM tourism.reviews
WHERE review_id = 5;

-- C11: Reservas + huésped
SELECT 
    b.booking_id, 
    b.booking_reference AS referencia, 
    g.first_name AS nombre_huesped, 
    g.last_name AS apellido_huesped, 
    b.check_in_date AS fecha_ingreso, 
    b.total_amount AS total_pago
FROM tourism.bookings b
INNER JOIN tourism.guests g 
    ON b.guest_id = g.guest_id
ORDER BY b.booking_id ASC;

-- C12: Alojamiento completo
SELECT 
    a.accommodation_id, 
    a.name AS alojamiento, 
    t.type_name AS tipo_alojamiento, 
    l.city AS ciudad, 
    l.country AS pais, 
    o.first_name || ' ' || o.last_name AS propietario,
    o.company_name AS empresa
FROM tourism.accommodations a
INNER JOIN tourism.accommodation_types t 
    ON a.accommodation_type_id = t.accommodation_type_id
INNER JOIN tourism.locations l 
    ON a.location_id = l.location_id
INNER JOIN tourism.owners o 
    ON a.owner_id = o.owner_id
ORDER BY a.accommodation_id ASC;

-- C13: Pagos + reservas
SELECT 
    p.payment_id, 
    b.booking_reference AS referencia_reserva, 
    p.payment_date AS fecha_pago, 
    p.amount AS monto_pagado, 
    p.payment_method AS metodo_pago, 
    p.payment_status AS estado_pago,
    b.total_amount AS total_requerido
FROM tourism.payments p
INNER JOIN tourism.bookings b 
    ON p.booking_id = b.booking_id
ORDER BY p.payment_date DESC;

-- C14: Sin reseñas
SELECT 
    a.accommodation_id, 
    a.name AS alojamiento, 
    r.review_id AS id_resena, 
    r.rating AS calificacion, 
    r.review_title AS titulo_resena
FROM tourism.accommodations a
LEFT JOIN tourism.reviews r 
    ON a.accommodation_id = r.accommodation_id
ORDER BY r.rating DESC NULLS LAST;

-- C15: Sin reseñas: filtrar null
SELECT 
    a.accommodation_id, 
    a.name AS alojamiento_sin_reservas, 
    a.base_price_per_night AS precio_base,
    a.currency_code AS moneda
FROM tourism.accommodations a
LEFT JOIN tourism.bookings b 
    ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL
ORDER BY a.accommodation_id ASC;

-- C16.	Total ingresos: función SUM
SELECT 
    SUM(amount) AS "TOTAL INGRESOS NETOS",
    COUNT(payment_id) AS "CANTIDAD TRANSACCIONES EXITOSAS"
FROM tourism.payments
WHERE payment_status = 'Completed';

-- C17.	Promedio rating: FUNCIÓN AVG
SELECT 
    ROUND(AVG(rating), 2) AS "PROMEDIO SATISFACCION",
    COUNT(review_id) AS "TOTAL RESEÑAS RECIBIDAS"
FROM tourism.reviews;

-- C18.	Top alojamientos: COUNT + LIMIT
SELECT 
    a.accommodation_id, 
    a.name AS "Alojamiento", 
    COUNT(b.booking_id) AS "TOTAL RESERVAS RECIBIDAS"
FROM tourism.accommodations a
INNER JOIN tourism.bookings b 
    ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY "TOTAL RESERVAS RECIBIDAS" DESC
LIMIT 5;

-- C19.	Más de 3 reservas: GROUP BY + HAVING
SELECT 
    a.accommodation_id, 
    a.name AS "Alojamientos", 
    COUNT(b.booking_id) AS "VOLUMEN DE RESERVAS"
FROM tourism.accommodations a
INNER JOIN tourism.bookings b 
    ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
HAVING COUNT(b.booking_id) > 3
ORDER BY "VOLUMEN DE RESERVAS" DESC;

-- C20. Alojamiento más caro: Subquery
SELECT 
    accommodation_id, 
    name AS "ALOJAMIENTOS", 
    base_price_per_night AS "PRECIO MAXIMO", 
    currency_code AS "MONEDA"
FROM tourism.accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night) 
    FROM tourism.accommodations
);