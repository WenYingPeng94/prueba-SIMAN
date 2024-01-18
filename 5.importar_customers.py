import pandas as pd
import pymysql

def obtenerConexion(): # conexion
    connection = pymysql.connect(
        host = "127.0.0.1",
        user = "root",
        password = "123456",
        db = "wendb"
    )
    return connection

def leer_archivo(ruta, separador, tipoArchivo): #leer archivo separado por comas
    if(tipoArchivo=='CSV'):
        leerArchivo = pd.read_csv(ruta, sep=separador)
        return leerArchivo.astype(str)
    else:
        leerArchivo = pd.read_excel(ruta)


def limpiar_archivo(df, tipo): #los que no tenga comillas dobles le coloca comillas dobles
    if(tipo == "customers"):
        for columna in df.columns:
            df[columna] = df[columna].apply(lambda x: f'"{x}"' if not
                                            str(x).startswith('"') and not
                                            str(x).endswith('"') else x)
            df[columna] = df[columna].apply(lambda x: x.replace('"',"") if isinstance(x, str) else x) #reemplaza las comillas dobles por nada para que vaya limpio en la base
            print(df[columna])
        return df
    return df

def cargar_TablaTemp_Customer(df, tipo): #inserta los datos dependiendo del archivo a leer
    try:
        conexion = obtenerConexion()
        cursor = conexion.cursor()
        
        if(tipo == "customers"):
            cursor.execute("TRUNCATE TABLE olist_customers_temp")
            query = "INSERT INTO olist_customers_temp(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) VALUES(%s, %s, %s, %s, %s)"

        for index, row in df.iterrows():
            print(query)
            cursor.execute(query, tuple(row))
            conexion.commit()
        print("Data tabla temporal insertada de forma correcta")
        
    except Exception as error:
        print(error)
    finally:
        print("Proceso finalizado")
        conexion.close()

def cargar_tabla_customer(): #ejecuta la insercion de tablas temporales para la tabla final order y order_review 
    try: 
        conexion = obtenerConexion()
        cursor = conexion.cursor()

        cursor.execute("CALL cargar_tabla_customer();")
    except Exception as error: 
        print(error)
    finally: 
        print("Data tabla customers insertada de forma correcta")
        conexion.close()

def main():
    df = leer_archivo("C:\\Users\\Wen Peng\\Desktop\\Archivos CSV\\olist_customers_dataset.csv", ",", "CSV")
    df = limpiar_archivo(df, "customers") 
    cargar_TablaTemp_Customer(df, "customers")
    cargar_tabla_customer()

if __name__ == "__main__":
    main()