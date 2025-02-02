import sys
import pandas as pd
import json
from datetime import datetime

# Fungsi untuk membaca Excel
def read_excel(file_path):
    df = pd.read_excel(file_path, sheet_name='Sheet1', header=0)
    df = df.dropna(how='all')        # Hapus baris jika seluruh nilainya NaN
    df = df.dropna(axis=1, how='all') # Hapus kolom jika seluruh nilainya NaN
    df = df.astype(str)              # Ubah semua kolom ke string
    data = df.to_dict(orient='records')
    return data

def search_data(file_path, key, value):
    df = pd.read_excel(file_path, sheet_name='Sheet1', header=0)
    df = df.dropna(how='all')
    df = df.dropna(axis=1, how='all')
    df = df.astype(str)
    result = df[df[key] == value].to_dict(orient='records')
    return result

def add_data(file_path, new_data):
    df = pd.read_excel(file_path, sheet_name='Sheet1', header=0)
    df = df.dropna(how='all')
    df = df.dropna(axis=1, how='all')
    df = df.astype(str)
    # Tambahkan nomor otomatis
    new_data['No'] = str(len(df) + 1)
    # Tambahkan data baru
    new_data_df = pd.DataFrame([new_data])
    df = pd.concat([df, new_data_df], ignore_index=True)
    # Tambahkan formula DATEDIF untuk menghitung umur
    for i in range(len(df)):
        df.at[i, 'TAHUN'] = f'=DATEDIF(G{i+2},$T$1,"Y")&" Tahun"'
        df.at[i, 'BULAN'] = f'=DATEDIF(G{i+2},$T$1,"YM")&" Bulan"'
        df.at[i, 'HARI'] = f'=DATEDIF(G{i+2},$T$1,"MD")&" Hari"'
    df.to_excel(file_path, sheet_name='Sheet1', index=False)

def update_data(file_path, key, value, updated_data):
    df = pd.read_excel(file_path, sheet_name='Sheet1', header=0)
    df = df.dropna(how='all')
    df = df.dropna(axis=1, how='all')
    df = df.astype(str)
    # Cari baris yang sesuai (misalnya berdasarkan NIK)
    indices = df.index[df[key] == value].tolist()
    for i in indices:
        for k, v in updated_data.items():
            if k in df.columns:
                df.at[i, k] = v
    # Tambahkan formula DATEDIF untuk menghitung umur
    for i in range(len(df)):
        df.at[i, 'TAHUN'] = f'=DATEDIF(G{i+2},$T$1,"Y")&" Tahun"'
        df.at[i, 'BULAN'] = f'=DATEDIF(G{i+2},$T$1,"YM")&" Bulan"'
        df.at[i, 'HARI'] = f'=DATEDIF(G{i+2},$T$1,"MD")&" Hari"'
    df.to_excel(file_path, sheet_name='Sheet1', index=False)

def delete_data(file_path, key, value):
    df = pd.read_excel(file_path, sheet_name='Sheet1', header=0)
    df = df.dropna(how='all')
    df = df.dropna(axis=1, how='all')
    df = df.astype(str)
    df = df[df[key] != value]
    df.to_excel(file_path, sheet_name='Sheet1', index=False)

def add_sheet(file_path, sheet_name):
    df = pd.read_excel(file_path, sheet_name='Sheet1', header=0)
    df = df.dropna(how='all')
    df = df.dropna(axis=1, how='all')
    df = df.astype(str)
    with pd.ExcelWriter(file_path, engine='openpyxl', mode='a') as writer:
        df.to_excel(writer, sheet_name=sheet_name, index=False)

def convert_datetime_to_string(data):
    for record in data:
        for key, value in record.items():
            if isinstance(value, pd.Timestamp):
                record[key] = value.strftime('%Y-%m-%d %H:%M:%S')
    return data

if __name__ == "__main__":
    command = sys.argv[1]
    file_path = sys.argv[2]

    if command == 'read':
        result = read_excel(file_path)
        result = convert_datetime_to_string(result)
        print(json.dumps(result))
    elif command == 'search':
        key = sys.argv[3]
        value = sys.argv[4]
        result = search_data(file_path, key, value)
        result = convert_datetime_to_string(result)
        print(json.dumps(result))
    elif command == 'add':
        new_data = json.loads(sys.argv[3])
        add_data(file_path, new_data)
    elif command == 'update':
        key = sys.argv[3]
        value = sys.argv[4]
        updated_data = json.loads(sys.argv[5])
        update_data(file_path, key, value, updated_data)
    elif command == 'delete':
        key = sys.argv[3]
        value = sys.argv[4]
        delete_data(file_path, key, value)
    elif command == 'add_sheet':
        sheet_name = sys.argv[3]
        add_sheet(file_path, sheet_name)