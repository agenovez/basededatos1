from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://usuario:password@localhost/nombre_base_datos'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# MODELO CLIENTE
class Cliente(db.Model):
    __tablename__ = 'tb_clientes'
    pk_id_cliente = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(40), nullable=False)
    telefono = db.Column(db.String(20), nullable=False)
    direccion = db.Column(db.Text)
    email = db.Column(db.String(40), unique=True)

# RUTA PARA MOSTRAR FORMULARIO Y LISTA DE CLIENTES
@app.route('/clientes', methods=['GET'])
def get_clientes():
    clientes = Cliente.query.all()
    return render_template('clientes.html', clientes=clientes)

# RUTA PARA CREAR CLIENTE
@app.route('/clientes', methods=['POST'])
def create_cliente():
    nombre = request.form['nombre']
    telefono = request.form['telefono']
    direccion = request.form.get('direccion')
    email = request.form['email']
    nuevo_cliente = Cliente(nombre=nombre, telefono=telefono, direccion=direccion, email=email)
    db.session.add(nuevo_cliente)
    db.session.commit()
    return redirect(url_for('get_clientes'))

# RUTA PARA EDITAR CLIENTE
@app.route('/clientes/<int:id>', methods=['GET', 'POST'])
def update_cliente(id):
    cliente = Cliente.query.get(id)
    if request.method == 'POST':
        cliente.nombre = request.form['nombre']
        cliente.telefono = request.form['telefono']
        cliente.direccion = request.form.get('direccion')
        cliente.email = request.form['email']
        db.session.commit()
        return redirect(url_for('get_clientes'))
    return render_template('editar_cliente.html', cliente=cliente)

# RUTA PARA ELIMINAR CLIENTE
@app.route('/clientes/<int:id>/delete', methods=['POST'])
def delete_cliente(id):
    cliente = Cliente.query.get(id)
    db.session.delete(cliente)
    db.session.commit()
    return redirect(url_for('get_clientes'))

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)
