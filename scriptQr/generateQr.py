import pandas as pd
import qrcode
from PIL import Image

# --- Configuración ---
archivo_excel = 'INVENTARIO BICICLETAS CORRECTO.xlsx'        
columna = 3                        
output_folder = 'qrcodes'             
formato_salida = 'png'                 
tamaño = 400                           

import os
os.makedirs(output_folder, exist_ok=True)

df = pd.read_excel(archivo_excel,dtype=str, engine='openpyxl', usecols=[columna])

# eliminar filas vacías
df = df.dropna()

for index, row in df.iterrows():
    texto = row[0]

    qr = qrcode.QRCode(
        version=1,
        box_size=10,
        border=4
    )
    #import pdb; pdb.set_trace()
    qr.add_data(f'Code: {texto}')
    qr.make(fit=True)
    img = qr.make_image(fill_color="#0c3e65", back_color="white").convert("RGB")

    img = img.resize((tamaño, tamaño), Image.LANCZOS)

    nombre_archivo = f'{output_folder}/{texto}.{formato_salida}'
    img.save(nombre_archivo)

    print(f"QR guardado: {nombre_archivo}")

print("✅ Códigos QR fueron generados.")
