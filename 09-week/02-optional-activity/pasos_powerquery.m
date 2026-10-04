let
    Origen = Csv.Document(File.Contents("C:\Users\INVENTARIO\Desktop\c2-mini-etl\ventas_sucias.csv"),[Delimiter=",", Columns=6, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Encabezados promovidos" = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    #"Tipos de datos corregidos" = Table.TransformColumnTypes(#"Encabezados promovidos",{{"ID", Int64.Type}, {"Fecha", type date}, {"Ciudad", type text}, {"Producto", type text}, {"Cantidad", Int64.Type}, {"Precio", Currency.Type}}),
    #"Quitar duplicados por ID" = Table.Distinct(#"Tipos de datos corregidos", {"ID"}),
    #"Recortar espacios en Ciudad" = Table.TransformColumns(#"Quitar duplicados por ID",{{"Ciudad", Text.Trim, type text}}),
    #"Unificar mayúsculas en Ciudad" = Table.TransformColumns(#"Recortar espacios en Ciudad",{{"Ciudad", Text.Proper, type text}}),
    #"Reemplazar nulos por 0 en Cantidad" = Table.ReplaceValue(#"Unificar mayúsculas en Ciudad",null,0,Replacer.ReplaceValue,{"Cantidad"}),
    #"Reemplazar nulos por 0 en Precio" = Table.ReplaceValue(#"Reemplazar nulos por 0 en Cantidad",null,0,Replacer.ReplaceValue,{"Precio"}),
    #"Restaurar tipos de Cantidad y Precio" = Table.TransformColumnTypes(#"Reemplazar nulos por 0 en Precio",{{"Cantidad", Int64.Type}, {"Precio", Currency.Type}}),
    #"Crear columna Ingreso" = Table.AddColumn(#"Restaurar tipos de Cantidad y Precio", "Ingreso", each [Cantidad]*[Precio]),
    #"Ingreso a decimal fijo" = Table.TransformColumnTypes(#"Crear columna Ingreso",{{"Ingreso", Currency.Type}}),
    #"Crear columna Tamaño Venta" = Table.AddColumn(#"Ingreso a decimal fijo", "Tamaño Venta", each if [Ingreso] >= 50000 then "Alta" else if [Ingreso] >= 20000 then "Media" else "Baja")
in
    #"Crear columna Tamaño Venta"