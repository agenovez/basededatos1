from flask import Flask, request, jsonify, render_template
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://usuario:password@localhost/nombre_base_datos'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# MODELOS
class Cliente(db.Model):
    __tablename__ = 'tb_clientes'
    pk_id_cliente = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(40), nullable=False)
    telefono = db.Column(db.String(20), nullable=False)
    direccion = db.Column(db.Text)
    email = db.Column(db.String(40), unique=True)

# RUTAS CRUD CLIENTES
@app.route('/clientes', methods=['GET'])
def get_clientes():
    clientes = Cliente.query.all()
    return jsonify([{ 'id': c.pk_id_cliente, 'nombre': c.nombre, 'telefono': c.telefono, 'email': c.email } for c in clientes])

@app.route('/clientes/<int:id>', methods=['GET'])
def get_cliente(id):
    cliente = Cliente.query.get(id)
    if not cliente:
        return jsonify({'error': 'Cliente no encontrado'}), 404
    return jsonify({ 'id': cliente.pk_id_cliente, 'nombre': cliente.nombre, 'telefono': cliente.telefono, 'email': cliente.email })

@app.route('/clientes', methods=['POST'])
def create_cliente():
    data = request.json
    nuevo_cliente = Cliente(nombre=data['nombre'], telefono=data['telefono'], direccion=data.get('direccion'), email=data['email'])
    db.session.add(nuevo_cliente)
    db.session.commit()
    return jsonify({'message': 'Cliente creado con éxito'}), 201

@app.route('/clientes/<int:id>', methods=['PUT'])
def update_cliente(id):
    cliente = Cliente.query.get(id)
    if not cliente:
        return jsonify({'error': 'Cliente no encontrado'}), 404
    data = request.json
    cliente.nombre = data.get('nombre', cliente.nombre)
    cliente.telefono = data.get('telefono', cliente.telefono)
    cliente.direccion = data.get('direccion', cliente.direccion)
    cliente.email = data.get('email', cliente.email)
    db.session.commit()
    return jsonify({'message': 'Cliente actualizado con éxito'})

@app.route('/clientes/<int:id>', methods=['DELETE'])
def delete_cliente(id):
    cliente = Cliente.query.get(id)
    if not cliente:
        return jsonify({'error': 'Cliente no encontrado'}), 404
    db.session.delete(cliente)
    db.session.commit()
    return jsonify({'message': 'Cliente eliminado con éxito'})

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)
