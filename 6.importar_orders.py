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
    if(tipo == "orders"):
        for columna in df.columns:
            df[columna] = df[columna].apply(lambda x: f'"{x}"' if not
                                            str(x).startswith('"') and not
                                            str(x).endswith('"') else x)
            df[columna] = df[columna].apply(lambda x: x.replace('"',"") if isinstance(x, str) else x) #reemplaza las comillas dobles por nada para que vaya limpio en la base
            print(df[columna])
        return df
    return df


def cargar_TablaTemp_Order(df, tipo): #inserta los datos dependiendo del archivo a leer
    try:
        conexion = obtenerConexion()
        cursor = conexion.cursor()
        
        if(tipo == "orders"):
            cursor.execute("TRUNCATE TABLE olist_orders_temp;")
            query = "INSERT INTO olist_orders_temp(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date) values (%s,%s,%s,%s,%s,%s,%s,%s)"

        for index, row in df.iterrows():
            cursor.execute(query, tuple(row))
            print(query)
            conexion.commit()
        print("Data tabla temporal insertada de forma correcta")
        
    except Exception as error:
        print(error)
    finally:
        print("Proceso finalizado")
        conexion.close()

def cargar_tabla_order(): #inserta datos de tabla temporal "olist_orders_temp" a "olist_orders_dataset"
    try: 
        conexion = obtenerConexion()
        cursor = conexion.cursor()

        cursor.execute("CALL cargar_tabla_order();")
    except Exception as error: 
        print(error)
    finally: 
        print("Data tabla orders insertada de forma correcta")
        conexion.close()

def main():
    df = leer_archivo("C:\\Users\\Wen Peng\\Desktop\\Archivos CSV\\olist_orders_dataset.csv", ",", "CSV")
    df = limpiar_archivo(df, "orders") 
    cargar_TablaTemp_Order(df, "orders")
    cargar_tabla_order()

if __name__ == "__main__":
    print("INICIO 20:38")
    main()