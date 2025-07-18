const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
const PORT = 3000;

// Middleware para parsear formularios
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Conexión a la base de datos
const db = mysql.createConnection({
  host: 'localhost',
  user: 'alumno',
  password: 'alumnoipm', 
  database: 'base_star_wars_foro'
});

db.connect((err) => {
  if (err) throw err;
  console.log('Conectado a la base de datos');
});

// Servir tu HTML si lo necesitás
const staticPath = path.resolve(__dirname, '..');
app.use(express.static(staticPath));

// Ruta para insertar nave
app.post('/agregar-nave', (req, res) => {
  const {
    nombre,
    tipo,
    faccion,
    descripcion_corta,
    nombre_fan,
    fecha,
    parte
  } = req.body;

  const sql = `
    INSERT INTO naves 
    (nombre, tipo, faccion, descripcion_corta, nombre_fan, fecha, parte)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [nombre, tipo, faccion, descripcion_corta, nombre_fan, fecha, parte], (err, result) => {
    if (err) {
      console.error('Error al insertar nave:', err);
      return res.status(500).send('Error al registrar la nave');
    }
    res.redirect('/soporte-informatico/index.html');
  });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
