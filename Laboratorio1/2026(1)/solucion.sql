-- =============================================================================
-- MODULO COM - COMERCIAL (Ejecutivos y Clientes)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: COM_EJECUTIVOS
-- Descripcion: Ejecutivos de ventas internos asignados a clientes mayoristas
-- -----------------------------------------------------------------------------
CREATE TABLE COM_EJECUTIVOS (
    EJECUTIVO_ID            NUMBER(6)       NOT NULL,
    NOMBRES                 VARCHAR2(15)    NOT NULL,
    APELLIDOS               VARCHAR2(15)    NOT NULL,
    CORREO                  VARCHAR2(100)   NOT NULL,
    ACTIVO                  NUMBER(1)       DEFAULT 1 NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_EJECUTIVOS            PRIMARY KEY (EJECUTIVO_ID),
    CONSTRAINT UQ_COM_EJECUTIVOS_CORREO     UNIQUE (CORREO),
    CONSTRAINT CK_COM_EJECUTIVOS_ACTIVO     CHECK (ACTIVO IN (0, 1))
);

COMMENT ON TABLE  COM_EJECUTIVOS                        IS 'Ejecutivos de ventas internos responsables de la atención a clientes mayoristas';
COMMENT ON COLUMN COM_EJECUTIVOS.EJECUTIVO_ID           IS 'Identificador único del ejecutivo de ventas';
COMMENT ON COLUMN COM_EJECUTIVOS.NOMBRES                IS 'Nombres del ejecutivo de ventas';
COMMENT ON COLUMN COM_EJECUTIVOS.APELLIDOS              IS 'Apellidos del ejecutivo de ventas';
COMMENT ON COLUMN COM_EJECUTIVOS.CORREO                 IS 'Correo electrónico institucional; debe ser único por ejecutivo';
COMMENT ON COLUMN COM_EJECUTIVOS.ACTIVO                 IS 'Indicador de estado: 1=activo, 0=inactivo';
COMMENT ON COLUMN COM_EJECUTIVOS.USUARIO_CREACION       IS 'Usuario que creó el registro';
COMMENT ON COLUMN COM_EJECUTIVOS.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación del registro';
COMMENT ON COLUMN COM_EJECUTIVOS.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO COM - COMPRAS (Proveedores) - se crea antes que ALM_MATERIAS_PRIMAS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: COM_PROVEEDORES
-- Descripcion: Proveedores de materias primas e insumos con condiciones comerciales
-- -----------------------------------------------------------------------------
CREATE TABLE COM_PROVEEDORES (
    PROVEEDOR_ID            NUMBER(6)       NOT NULL,
    RAZON_SOCIAL            VARCHAR2(150)   NOT NULL,
    RUC                     VARCHAR2(11)    NOT NULL,
    RUBRO_SUMINISTRO        VARCHAR2(100)   NOT NULL,
    DIRECCION               VARCHAR2(200),
    TELEFONO                VARCHAR2(20),    
    PLAZO_ENTREGA_DIAS      NUMBER(3)       DEFAULT 0 NOT NULL,
    DESC_VOLUMEN_PCT        NUMBER(5,2)     DEFAULT 0 NOT NULL,
    ACTIVO                  NUMBER(1)       DEFAULT 1 NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_PROVEEDORES               PRIMARY KEY (PROVEEDOR_ID),
    CONSTRAINT UQ_COM_PROVEEDORES_RUC           UNIQUE (RUC),
    CONSTRAINT CK_COM_PROVEEDORES_RUC           CHECK (LENGTH(RUC) = 11 AND REGEXP_LIKE(RUC, '^[0-9]+$')),
    CONSTRAINT CK_COM_PROVEEDORES_PLAZO         CHECK (PLAZO_ENTREGA_DIAS >= 0),
    CONSTRAINT CK_COM_PROVEEDORES_DESC          CHECK (DESC_VOLUMEN_PCT BETWEEN 0 AND 100),
    CONSTRAINT CK_COM_PROVEEDORES_ACTIVO        CHECK (ACTIVO IN (0, 1))
);

COMMENT ON TABLE  COM_PROVEEDORES                        IS 'Proveedores de materias primas e insumos con sus condiciones comerciales acordadas';
COMMENT ON COLUMN COM_PROVEEDORES.PROVEEDOR_ID           IS 'Identificador único del proveedor';
COMMENT ON COLUMN COM_PROVEEDORES.RAZON_SOCIAL           IS 'Razón social del proveedor según SUNAT';
COMMENT ON COLUMN COM_PROVEEDORES.RUC                    IS 'RUC del proveedor, 11 dígitos numéricos, debe ser único';
COMMENT ON COLUMN COM_PROVEEDORES.RUBRO_SUMINISTRO       IS 'Descripción del tipo de insumos que provee (ej. Cueros y pieles, Suelas y plantas)';
COMMENT ON COLUMN COM_PROVEEDORES.DIRECCION              IS 'Dirección fiscal del proveedor';
COMMENT ON COLUMN COM_PROVEEDORES.TELEFONO               IS 'Teléfono de contacto del proveedor';
COMMENT ON COLUMN COM_PROVEEDORES.PLAZO_ENTREGA_DIAS     IS 'Plazo habitual de entrega en días calendario contados desde la emisión de la OC';
COMMENT ON COLUMN COM_PROVEEDORES.DESC_VOLUMEN_PCT       IS 'Porcentaje de descuento por volumen acordado con el proveedor (0 si no aplica)';
COMMENT ON COLUMN COM_PROVEEDORES.ACTIVO                 IS 'Indicador de estado: 1=activo, 0=inactivo (proveedor dado de baja)';
COMMENT ON COLUMN COM_PROVEEDORES.FECHA_CREACION         IS 'Fecha en que se registró el proveedor';
COMMENT ON COLUMN COM_PROVEEDORES.USUARIO_CREACION       IS 'Usuario que creó el registro';
COMMENT ON COLUMN COM_PROVEEDORES.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_PROVEEDORES.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO COM - COMERCIAL (Pedidos)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: COM_CONDICIONES_PAGO
-- Descripcion: Historial de condiciones de pago por cliente.
--              Un cliente solo puede tener una condicion con VIGENTE = 1.
-- -----------------------------------------------------------------------------
CREATE TABLE COM_CONDICIONES_PAGO (
    CONDICION_PAGO_ID       NUMBER(6)       NOT NULL,
    DIAS_CREDITO            NUMBER(3)       NOT NULL,
    DESC_COMERCIAL_PCT      NUMBER(5,2)     DEFAULT 0 NOT NULL,
    FECHA_INICIO            DATE            NOT NULL,
    FECHA_FIN               DATE,
    VIGENTE                 NUMBER(1)       DEFAULT 1 NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT CK_COM_CONDPAGO_DIAS         CHECK (DIAS_CREDITO >= 0),
    CONSTRAINT CK_COM_CONDPAGO_DESC         CHECK (DESC_COMERCIAL_PCT BETWEEN 0 AND 100),
    CONSTRAINT CK_COM_CONDPAGO_VIGENTE      CHECK (VIGENTE IN (0, 1)),
    CONSTRAINT CK_COM_CONDPAGO_FECHAS       CHECK (FECHA_FIN IS NULL OR FECHA_FIN > FECHA_INICIO)
);

COMMENT ON TABLE  COM_CONDICIONES_PAGO                       IS 'Historial de condiciones de pago por cliente; solo un registro puede tener VIGENTE=1 por cliente en un momento dado';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.CONDICION_PAGO_ID     IS 'Identificador único de la condición de pago';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.DIAS_CREDITO          IS 'Número de días de crédito otorgados (0 = pago al contado)';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.DESC_COMERCIAL_PCT    IS 'Porcentaje de descuento comercial aplicable sobre el precio de venta sugerido';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.FECHA_INICIO          IS 'Fecha desde la que rige esta condición de pago';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.FECHA_FIN             IS 'Fecha hasta la que rigió esta condición; NULL si es la condición actualmente vigente';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.VIGENTE               IS 'Indicador: 1=condición vigente, 0=condición histórica';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.FECHA_CREACION        IS 'Fecha de registro de la condición';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.USUARIO_CREACION      IS 'Usuario que creó el registro';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.FECHA_ACTUALIZACION   IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_CONDICIONES_PAGO.USUARIO_ACTUALIZACION IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO CAT - CATALOGO
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: CAT_MODELOS
-- Descripcion: Catálogo de modelos de calzado que fabrica y comercializa la empresa
-- -----------------------------------------------------------------------------
CREATE TABLE CAT_MODELOS (
    MODELO_ID               NUMBER(6)       NOT NULL,
    CODIGO                  VARCHAR2(20)    NOT NULL,
    NOMBRE_COMERCIAL        VARCHAR2(100)   NOT NULL,
    LINEA                   VARCHAR2(15)    NOT NULL,
    TIPO_CALZADO            VARCHAR2(30)    NOT NULL,
    IND_IMPORTADO           CHAR(1)         DEFAULT 'N' NULL,
    DESCRIPCION             VARCHAR2(500),
    PRECIO_MAYOR            NUMBER(10,2)    NOT NULL,
    ESTADO                  VARCHAR2(15)    DEFAULT 'ACTIVO' NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_CAT_MODELOS               PRIMARY KEY (MODELO_ID),
    CONSTRAINT UQ_CAT_MODELOS_CODIGO        UNIQUE (CODIGO),
    CONSTRAINT CK_CAT_MODELOS_LINEA         CHECK (LINEA IN ('DAMAS', 'CABALLEROS', 'NINOS')),
    CONSTRAINT CK_CAT_MODELOS_TIPO          CHECK (TIPO_CALZADO IN ('OXFORD', 'MOCASIN', 'SANDALIA', 'BOTA', 'DEPORTIVO', 'CASUAL', 'OTRO')),
    CONSTRAINT CK_CAT_MODELOS_ESTADO        CHECK (ESTADO IN ('ACTIVO', 'SUSPENDIDO', 'DESCONTINUADO')),
    CONSTRAINT CK_CAT_MODELOS_PRECIO        CHECK (PRECIO_MAYOR > 0)
);

COMMENT ON TABLE  CAT_MODELOS                           IS 'Catálogo de modelos de calzado; solo los modelos con ESTADO=ACTIVO pueden incluirse en nuevos pedidos';
COMMENT ON COLUMN CAT_MODELOS.MODELO_ID                 IS 'Identificador único interno del modelo';
COMMENT ON COLUMN CAT_MODELOS.CODIGO                    IS 'Código comercial único del modelo asignado por la empresa (ej. DM-001, CB-045)';
COMMENT ON COLUMN CAT_MODELOS.NOMBRE_COMERCIAL          IS 'Nombre comercial del modelo de calzado';
COMMENT ON COLUMN CAT_MODELOS.LINEA                     IS 'Línea de producto: DAMAS, CABALLEROS o NIÑOS';
COMMENT ON COLUMN CAT_MODELOS.TIPO_CALZADO              IS 'Tipo de calzado: OXFORD, MOCASÍN, SANDALIA, BOTA, DEPORTIVO, CASUAL u OTRO';
COMMENT ON COLUMN CAT_MODELOS.IND_IMPORTADO             IS 'Indicador de si el modelo es importado (N para Nacional o I para Internacional)';
COMMENT ON COLUMN CAT_MODELOS.DESCRIPCION               IS 'Descripción del diseño y características del modelo';
COMMENT ON COLUMN CAT_MODELOS.PRECIO_MAYOR              IS 'Precio de venta sugerido al por mayor en soles; debe ser mayor a cero';
COMMENT ON COLUMN CAT_MODELOS.ESTADO                    IS 'Estado: ACTIVO (disponible para pedidos), SUSPENDIDO (temporal), DESCONTINUADO (no se fabrica más)';
COMMENT ON COLUMN CAT_MODELOS.FECHA_CREACION            IS 'Fecha de registro del modelo en el catálogo';
COMMENT ON COLUMN CAT_MODELOS.USUARIO_CREACION          IS 'Usuario que creó el registro';
COMMENT ON COLUMN CAT_MODELOS.FECHA_ACTUALIZACION       IS 'Fecha de la última modificación';
COMMENT ON COLUMN CAT_MODELOS.USUARIO_ACTUALIZACION     IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO ALM - ALMACEN
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: ALM_MATERIAS_PRIMAS
-- Descripcion: Catálogo de materias primas e insumos utilizados en produccion
-- -----------------------------------------------------------------------------
CREATE TABLE ALM_MATERIAS_PRIMAS (
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    CODIGO                  VARCHAR2(20)    NOT NULL,
    DESCRIPCION             VARCHAR2(150)   NOT NULL,
    UNIDAD_MEDIDA           VARCHAR2(20)    NOT NULL,
    STOCK_ACTUAL            NUMBER(12,3)    DEFAULT 0 NOT NULL,
    STOCK_MINIMO            NUMBER(12,3)    DEFAULT 0 NOT NULL,
    COSTO_UNIT_PROMEDIO     NUMBER(10,4)    DEFAULT 0 NOT NULL,
    PROVEEDOR_PPAL_ID       NUMBER(6),
    ACTIVO                  NUMBER(1)       DEFAULT 1 NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_ALM_MATERIAS_PRIMAS           PRIMARY KEY (MATERIA_PRIMA_ID),
    CONSTRAINT UQ_ALM_MAT_PRIMAS_CODIGO         UNIQUE (CODIGO),
    CONSTRAINT FK_ALM_MATPRIM_PROVEEDORES       FOREIGN KEY (PROVEEDOR_PPAL_ID) REFERENCES COM_PROVEEDORES(PROVEEDOR_ID),
    CONSTRAINT CK_ALM_MATPRIM_STOCK             CHECK (STOCK_ACTUAL >= 0),
    CONSTRAINT CK_ALM_MATPRIM_STOCK_MIN         CHECK (STOCK_MINIMO >= 0),
    CONSTRAINT CK_ALM_MATPRIM_COSTO             CHECK (COSTO_UNIT_PROMEDIO >= 0),
    CONSTRAINT CK_ALM_MATPRIM_ACTIVO            CHECK (ACTIVO IN (0, 1))
);

COMMENT ON TABLE  ALM_MATERIAS_PRIMAS                        IS 'Catálogo de materias primas; STOCK_ACTUAL se actualiza automáticamente con cada movimiento de almacén';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.MATERIA_PRIMA_ID       IS 'Identificador único de la materia prima';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.CODIGO                 IS 'Código interno único de la materia prima';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.DESCRIPCION            IS 'Descripción del insumo (ej. Cuero natural bovino, Planta caucho talla 40)';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.UNIDAD_MEDIDA          IS 'Unidad en que se mide el insumo: M2, ML, UND, LT, KG, etc.';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.STOCK_ACTUAL           IS 'Cantidad disponible en almacén expresada en la unidad de medida del insumo';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.STOCK_MINIMO           IS 'Nivel de stock de seguridad; al caer por debajo se genera alerta automática de reposición';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.COSTO_UNIT_PROMEDIO    IS 'Costo unitario promedio ponderado; se actualiza con cada entrada al almacén';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.PROVEEDOR_PPAL_ID      IS 'FK al proveedor principal habitual; puede ser NULL si no hay proveedor preferido definido';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.ACTIVO                 IS 'Indicador de estado: 1=activo, 0=dado de baja del catálogo';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.FECHA_CREACION         IS 'Fecha de registro del insumo en el catálogo';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.USUARIO_CREACION       IS 'Usuario que creó el registro';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN ALM_MATERIAS_PRIMAS.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO CAT - Fichas Tecnicas (requiere ALM_MATERIAS_PRIMAS y CAT_MODELOS)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: CAT_FICHAS_TECNICAS
-- Descripcion: Versiones de fichas técnicas por modelo. Permite historizar
--              cambios en la composicion de insumos a lo largo del tiempo.
-- -----------------------------------------------------------------------------
CREATE TABLE CAT_FICHAS_TECNICAS (
    FICHA_ID                NUMBER(8)       NOT NULL,
    MODELO_ID               NUMBER(6)       NOT NULL,
    VERSION                 NUMBER(4)       NOT NULL,
    FECHA_VIGENCIA          DATE            NOT NULL,
    FECHA_FIN               DATE,
    VIGENTE                 NUMBER(1)       DEFAULT 1 NOT NULL,
    DESCRIPCION             VARCHAR2(300),    
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_CAT_FICHAS_TECNICAS       PRIMARY KEY (FICHA_ID),
    CONSTRAINT FK_CAT_FICHAS_MODELOS        FOREIGN KEY (MODELO_ID) REFERENCES CAT_MODELOS(MODELO_ID),
    CONSTRAINT UQ_CAT_FICHAS_MOD_VER        UNIQUE (MODELO_ID, VERSION),
    CONSTRAINT CK_CAT_FICHAS_VIGENTE        CHECK (VIGENTE IN (0, 1)),
    CONSTRAINT CK_CAT_FICHAS_FECHAS         CHECK (FECHA_FIN IS NULL OR FECHA_FIN > FECHA_VIGENCIA)
);

COMMENT ON TABLE  CAT_FICHAS_TECNICAS                        IS 'Versiones de ficha técnica por modelo; cada revisión de insumos genera una nueva versión historizada';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.FICHA_ID               IS 'Identificador único de la versión de ficha técnica';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.MODELO_ID              IS 'FK al modelo al que corresponde esta ficha técnica';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.VERSION                IS 'Número de versión; se incrementa con cada revisión aprobada';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.FECHA_VIGENCIA         IS 'Fecha desde la que aplica esta versión de la ficha';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.FECHA_FIN              IS 'Fecha hasta la que aplicó esta versión; NULL si es la versión vigente';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.VIGENTE                IS 'Indicador: 1=versión actualmente vigente, 0=versión histórica';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.DESCRIPCION            IS 'Descripción del motivo del cambio de versión (opcional)';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.USUARIO_CREACION       IS 'Usuario que registró la versión';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN CAT_FICHAS_TECNICAS.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: CAT_DETALLES_FICHAS
-- Descripcion: Insumos y cantidades requeridos por par para cada talla,
--              según una versión especifica de ficha técnica
-- -----------------------------------------------------------------------------
CREATE TABLE CAT_DETALLES_FICHAS (
    DET_FICHA_ID            NUMBER(10)      NOT NULL,
    FICHA_ID                NUMBER(8)       NOT NULL,
    TALLA                   VARCHAR2(10)    NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    CANTIDAD_POR_PAR        NUMBER(10,4)    NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_CAT_DETALLES_FICHAS           PRIMARY KEY (DET_FICHA_ID),
    CONSTRAINT FK_CAT_DETFIC_FICHAS             FOREIGN KEY (FICHA_ID)          REFERENCES CAT_FICHAS_TECNICAS(FICHA_ID),
    CONSTRAINT FK_CAT_DETFIC_MAT_PRIMAS         FOREIGN KEY (MATERIA_PRIMA_ID)  REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT UQ_CAT_DETFIC_FIC_TALL_MAT       UNIQUE (FICHA_ID, TALLA, MATERIA_PRIMA_ID),
    CONSTRAINT CK_CAT_DETFIC_CANTIDAD           CHECK (CANTIDAD_POR_PAR > 0)
);

COMMENT ON TABLE  CAT_DETALLES_FICHAS                        IS 'Detalle de insumos y cantidades por par para cada talla segun una versión de ficha técnica';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.DET_FICHA_ID           IS 'Identificador único del detalle de ficha técnica';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.FICHA_ID               IS 'FK a la versión de ficha técnica a la que pertenece este detalle';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.TALLA                  IS 'Talla del calzado para la que aplica este requerimiento (ej. 36, 38, 40, 42)';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.MATERIA_PRIMA_ID       IS 'FK al insumo requerido para producir esta talla según la ficha';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.CANTIDAD_POR_PAR       IS 'Cantidad del insumo requerida por cada par producido en esta talla; debe ser mayor a cero';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.FECHA_CREACION         IS 'Fecha de registro del detalle';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.USUARIO_CREACION       IS 'Usuario que registró el detalle';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN CAT_DETALLES_FICHAS.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO COM - Pedidos (requiere CAT_MODELOS y COM_CLIENTES)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: COM_PEDIDOS
-- Descripcion: Pedidos de fabricación de clientes mayoristas o para stock propio
-- -----------------------------------------------------------------------------
CREATE TABLE COM_PEDIDOS (
    PEDIDO_ID               NUMBER(8)       NOT NULL,
    FECHA_EMISION           DATE            DEFAULT SYSDATE NOT NULL,
    FECHA_ENTREGA_COMP      DATE            NOT NULL,
    TIPO_PEDIDO             VARCHAR2(15)    NOT NULL,
    ESTADO                  VARCHAR2(20)    DEFAULT 'RECIBIDO' NOT NULL,
    OBSERVACIONES           VARCHAR2(500),
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_PEDIDOS               PRIMARY KEY (PEDIDO_ID),
    CONSTRAINT CK_COM_PEDIDOS_TIPO          CHECK (TIPO_PEDIDO IN ('POR_PEDIDO', 'PARA_STOCK')),
    CONSTRAINT CK_COM_PEDIDOS_ESTADO        CHECK (ESTADO IN ('RECIBIDO', 'EN_PRODUCCION', 'COMPLETADO', 'CANCELADO')),
    CONSTRAINT CK_COM_PEDIDOS_FECHA         CHECK (FECHA_ENTREGA_COMP > FECHA_EMISION)
);

COMMENT ON TABLE  COM_PEDIDOS                           IS 'Pedidos de fabricación originados por clientes (POR_PEDIDO) o por iniciativa propia para stock (PARA_STOCK)';
COMMENT ON COLUMN COM_PEDIDOS.PEDIDO_ID                 IS 'Identificador único del pedido de fabricacion';
COMMENT ON COLUMN COM_PEDIDOS.FECHA_EMISION             IS 'Fecha en que se recibió o generó el pedido';
COMMENT ON COLUMN COM_PEDIDOS.FECHA_ENTREGA_COMP        IS 'Fecha comprometida de entrega al cliente; debe ser posterior a la fecha de emision';
COMMENT ON COLUMN COM_PEDIDOS.TIPO_PEDIDO               IS 'POR_PEDIDO: encargo de cliente; PARA_STOCK: producción anticipada por iniciativa propia';
COMMENT ON COLUMN COM_PEDIDOS.ESTADO                    IS 'Estado actual: RECIBIDO, EN_PRODUCCION, COMPLETADO o CANCELADO';
COMMENT ON COLUMN COM_PEDIDOS.OBSERVACIONES             IS 'Notas o instrucciones adicionales sobre el pedido';
COMMENT ON COLUMN COM_PEDIDOS.FECHA_CREACION            IS 'Fecha de registro del pedido en el sistema';
COMMENT ON COLUMN COM_PEDIDOS.USUARIO_CREACION          IS 'Usuario que creó el registro';
COMMENT ON COLUMN COM_PEDIDOS.FECHA_ACTUALIZACION       IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_PEDIDOS.USUARIO_ACTUALIZACION     IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: COM_DETALLES_PEDIDOS
-- Descripcion: Líneas de detalle de cada pedido: modelo, talla y cantidad pedida
-- -----------------------------------------------------------------------------
CREATE TABLE COM_DETALLES_PEDIDOS (    
    PEDIDO_ID               NUMBER(8)       NOT NULL,
    MODELO_ID               NUMBER(6)       NOT NULL,
    TALLA                   VARCHAR2(10)    NOT NULL,
    CANTIDAD_PARES          NUMBER(6)       NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),    
    CONSTRAINT FK_COM_DETPED_PEDIDOS            FOREIGN KEY (PEDIDO_ID)  REFERENCES COM_PEDIDOS(PEDIDO_ID),
    CONSTRAINT FK_COM_DETPED_MODELOS            FOREIGN KEY (MODELO_ID)  REFERENCES CAT_MODELOS(MODELO_ID),
    CONSTRAINT UQ_COM_DETPED_PED_MOD_TALL       UNIQUE (PEDIDO_ID, MODELO_ID, TALLA),
    CONSTRAINT CK_COM_DETPED_CANTIDAD           CHECK (CANTIDAD_PARES > 0)
);

COMMENT ON TABLE  COM_DETALLES_PEDIDOS                        IS 'Líneas de detalle de un pedido; cada línea representa un modelo, talla y cantidad específica solicitada';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.PEDIDO_ID              IS 'FK al pedido al que pertenece esta línea';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.MODELO_ID              IS 'FK al modelo de calzado solicitado; solo se permiten modelos ACTIVOS';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.TALLA                  IS 'Talla del calzado solicitado en esta línea';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.CANTIDAD_PARES         IS 'Cantidad de pares solicitados para este modelo y talla; debe ser mayor a cero';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.FECHA_CREACION         IS 'Fecha de registro de la línea';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.USUARIO_CREACION       IS 'Usuario que registró la línea';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_DETALLES_PEDIDOS.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO COM - COMPRAS (Precios, OC, Entregas)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: COM_PRECIOS_PACTADOS
-- Descripcion: Historial de precios pactados por proveedor y materia prima.
--              Solo el registro con VIGENTE=1 aplica a nuevas ordenes de compra.
-- -----------------------------------------------------------------------------
CREATE TABLE COM_PRECIOS_PACTADOS (
    PRECIO_PACTADO_ID       NUMBER(8)       NOT NULL,
    PROVEEDOR_ID            NUMBER(6)       NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    PRECIO_UNITARIO         NUMBER(10,4)    NOT NULL,
    FECHA_VIGENCIA          DATE            NOT NULL,
    FECHA_FIN               DATE,
    VIGENTE                 NUMBER(1)       DEFAULT 1 NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_PRECIOS_PACTADOS          PRIMARY KEY (PRECIO_PACTADO_ID),
    CONSTRAINT FK_COM_PRECPACT_PROVEEDORES      FOREIGN KEY (PROVEEDOR_ID)      REFERENCES COM_PROVEEDORES(PROVEEDOR_ID),
    CONSTRAINT FK_COM_PRECPACT_MAT_PRIMAS       FOREIGN KEY (MATERIA_PRIMA_ID)  REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT CK_COM_PRECPACT_PRECIO           CHECK (PRECIO_UNITARIO > 0),
    CONSTRAINT CK_COM_PRECPACT_VIGENTE          CHECK (VIGENTE IN (0, 1)),
    CONSTRAINT CK_COM_PRECPACT_FECHAS           CHECK (FECHA_FIN IS NULL OR FECHA_FIN > FECHA_VIGENCIA)
);

COMMENT ON TABLE  COM_PRECIOS_PACTADOS                        IS 'Historial de precios acordados por proveedor y materia prima; solo VIGENTE=1 aplica a nuevas OC';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.PRECIO_PACTADO_ID      IS 'Identificador único del precio pactado';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.PROVEEDOR_ID           IS 'FK al proveedor con quien se pactó el precio';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.MATERIA_PRIMA_ID       IS 'FK a la materia prima a la que aplica el precio';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.PRECIO_UNITARIO        IS 'Precio unitario pactado en soles por unidad de medida del insumo; debe ser mayor a cero';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.FECHA_VIGENCIA         IS 'Fecha desde la que aplica este precio pactado';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.FECHA_FIN              IS 'Fecha hasta la que aplicó este precio; NULL si es el precio vigente';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.VIGENTE                IS 'Indicador: 1=precio actualmente vigente, 0=precio histórico';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.FECHA_CREACION         IS 'Fecha de registro del precio';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.USUARIO_CREACION       IS 'Usuario que registró el precio';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_PRECIOS_PACTADOS.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: COM_ORDENES_COMPRA
-- Descripcion: Órdenes de compra emitidas a proveedores para reponer inventario
-- -----------------------------------------------------------------------------
CREATE TABLE COM_ORDENES_COMPRA (
    ORDEN_COMP_ID               NUMBER(8)       NOT NULL,
    PROVEEDOR_ID                NUMBER(6)       NOT NULL,
    FECHA_EMISION               DATE            DEFAULT SYSDATE NOT NULL,
    FECHA_ENTREGA_ESPERADA      DATE            NOT NULL,
    ESTADO                      VARCHAR2(25)    DEFAULT 'EMITIDA' NOT NULL,
    OBSERVACIONES               VARCHAR2(500),
    FECHA_CREACION              DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION            VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION         DATE,
    USUARIO_ACTUALIZACION       VARCHAR2(50),
    CONSTRAINT PK_COM_ORDENES_COMPRA            PRIMARY KEY (ORDEN_COMP_ID),
    CONSTRAINT FK_COM_ORDCOMP_PROVEEDORES       FOREIGN KEY (PROVEEDOR_ID) REFERENCES COM_PROVEEDORES(PROVEEDOR_ID),
    CONSTRAINT CK_COM_ORDCOMP_ESTADO            CHECK (ESTADO IN ('EMITIDA', 'ATENDIDA_PARCIAL', 'ATENDIDA_COMPLETA', 'ANULADA')),
    CONSTRAINT CK_COM_ORDCOMP_FECHA             CHECK (FECHA_ENTREGA_ESPERADA >= FECHA_EMISION)
);

COMMENT ON TABLE  COM_ORDENES_COMPRA                            IS 'Órdenes de compra emitidas a proveedores; pueden atenderse en una o varias entregas parciales';
COMMENT ON COLUMN COM_ORDENES_COMPRA.ORDEN_COMP_ID              IS 'Identificador único de la orden de compra';
COMMENT ON COLUMN COM_ORDENES_COMPRA.PROVEEDOR_ID               IS 'FK al proveedor al que se emite la orden';
COMMENT ON COLUMN COM_ORDENES_COMPRA.FECHA_EMISION              IS 'Fecha en que se emitió la orden de compra';
COMMENT ON COLUMN COM_ORDENES_COMPRA.FECHA_ENTREGA_ESPERADA     IS 'Fecha en que se espera recibir los insumos según el proveedor';
COMMENT ON COLUMN COM_ORDENES_COMPRA.ESTADO                     IS 'Estado de la OC: EMITIDA, ATENDIDA_PARCIAL, ATENDIDA_COMPLETA o ANULADA';
COMMENT ON COLUMN COM_ORDENES_COMPRA.OBSERVACIONES              IS 'Notas adicionales sobre la orden de compra';
COMMENT ON COLUMN COM_ORDENES_COMPRA.FECHA_CREACION             IS 'Fecha de registro de la OC en el sistema';
COMMENT ON COLUMN COM_ORDENES_COMPRA.USUARIO_CREACION           IS 'Usuario que registró la OC';
COMMENT ON COLUMN COM_ORDENES_COMPRA.FECHA_ACTUALIZACION        IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_ORDENES_COMPRA.USUARIO_ACTUALIZACION      IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: COM_DETALLES_ORDENES_COMP
-- Descripcion: Líneas de detalle de cada OC: insumo solicitado, cantidad y precio
-- -----------------------------------------------------------------------------
CREATE TABLE COM_DETALLES_ORDENES_COMP (
    DET_ORD_COMP_ID         NUMBER(10)      NOT NULL,
    ORDEN_COMP_ID           NUMBER(8)       NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    CANTIDAD_SOLICITADA     NUMBER(12,3)    NOT NULL,
    PRECIO_UNITARIO         NUMBER(10,4)    NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_DET_ORDENES_COMP          PRIMARY KEY (DET_ORD_COMP_ID),
    CONSTRAINT FK_COM_DETOC_ORDENES_COMP        FOREIGN KEY (ORDEN_COMP_ID)     REFERENCES COM_ORDENES_COMPRA(ORDEN_COMP_ID),
    CONSTRAINT FK_COM_DETOC_MAT_PRIMAS          FOREIGN KEY (MATERIA_PRIMA_ID)  REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT UQ_COM_DETOC_OC_MAT              UNIQUE (ORDEN_COMP_ID, MATERIA_PRIMA_ID),
    CONSTRAINT CK_COM_DETOC_CANTIDAD            CHECK (CANTIDAD_SOLICITADA > 0),
    CONSTRAINT CK_COM_DETOC_PRECIO              CHECK (PRECIO_UNITARIO > 0)
);

COMMENT ON TABLE  COM_DETALLES_ORDENES_COMP                         IS 'Líneas de detalle de una OC; cada línea especifica un insumo, la cantidad pedida y el precio acordado';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.DET_ORD_COMP_ID         IS 'Identificador único de la línea de detalle de la OC';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.ORDEN_COMP_ID           IS 'FK a la orden de compra a la que pertenece esta línea';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.MATERIA_PRIMA_ID        IS 'FK al insumo solicitado; un insumo no puede repetirse dentro de la misma OC';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.CANTIDAD_SOLICITADA     IS 'Cantidad total solicitada del insumo en la unidad de medida del catálogo';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.PRECIO_UNITARIO         IS 'Precio unitario acordado para esta OC; debe coincidir con el precio vigente del proveedor';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.FECHA_CREACION          IS 'Fecha de registro de la línea';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.USUARIO_CREACION        IS 'Usuario que registró la línea';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.FECHA_ACTUALIZACION     IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_DETALLES_ORDENES_COMP.USUARIO_ACTUALIZACION   IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: COM_ENTREGAS_PROVEEDOR
-- Descripcion: Entregas fisicas realizadas por el proveedor en respuesta a una OC.
--              Una OC puede ser atendida en varias entregas parciales.
-- -----------------------------------------------------------------------------
CREATE TABLE COM_ENTREGAS_PROVEEDOR (
    ENTREGA_ID              NUMBER(10)      NOT NULL,
    ORDEN_COMP_ID           NUMBER(8)       NOT NULL,
    FECHA_ENTREGA           DATE            NOT NULL,
    NRO_GUIA_REMISION       VARCHAR2(30)    NOT NULL,
    CONFORMIDAD             VARCHAR2(15)    DEFAULT 'CONFORME' NOT NULL,
    OBSERVACIONES           VARCHAR2(300),
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_ENTREGAS_PROVEEDOR        PRIMARY KEY (ENTREGA_ID),
    CONSTRAINT FK_COM_ENTREGAS_ORDENES_COMP     FOREIGN KEY (ORDEN_COMP_ID) REFERENCES COM_ORDENES_COMPRA(ORDEN_COMP_ID),
    CONSTRAINT CK_COM_ENTREGAS_CONFORMIDAD      CHECK (CONFORMIDAD IN ('CONFORME', 'OBSERVADO', 'RECHAZADO'))
);

COMMENT ON TABLE  COM_ENTREGAS_PROVEEDOR                        IS 'Registro de cada entrega física del proveedor; una OC puede tener varias entregas hasta completarse';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.ENTREGA_ID             IS 'Identificador único de la entrega del proveedor';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.ORDEN_COMP_ID          IS 'FK a la orden de compra que originó esta entrega; no se admiten entregas de OC ANULADAS';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.FECHA_ENTREGA          IS 'Fecha en que se recibió físicamente la mercadería en el almacén';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.NRO_GUIA_REMISION      IS 'Número de guía de remisión del proveedor que acompaña la entrega';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.CONFORMIDAD            IS 'Estado de conformidad de la recepción: CONFORME, OBSERVADO (con reparos) o RECHAZADO';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.OBSERVACIONES          IS 'Detalle de observaciones de la recepción (faltantes, daños, discrepancias)';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.FECHA_CREACION         IS 'Fecha de registro de la entrega en el sistema';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.USUARIO_CREACION       IS 'Usuario que registró la entrega';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_ENTREGAS_PROVEEDOR.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: COM_DETALLES_ENTREGAS
-- Descripcion: Cantidades efectivamente recibidas por insumo en cada entrega.
--              Origina movimientos de entrada en ALM_MOVIMIENTOS.
-- -----------------------------------------------------------------------------
CREATE TABLE COM_DETALLES_ENTREGAS (
    DET_ENTREGA_ID          NUMBER(10)      NOT NULL,
    ENTREGA_ID              NUMBER(10)      NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    CANTIDAD_RECIBIDA       NUMBER(12,3)    NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_COM_DETALLES_ENTREGAS         PRIMARY KEY (DET_ENTREGA_ID),
    CONSTRAINT FK_COM_DETENT_ENTREGAS           FOREIGN KEY (ENTREGA_ID)        REFERENCES COM_ENTREGAS_PROVEEDOR(ENTREGA_ID),
    CONSTRAINT FK_COM_DETENT_MAT_PRIMAS         FOREIGN KEY (MATERIA_PRIMA_ID)  REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT UQ_COM_DETENT_ENT_MAT            UNIQUE (ENTREGA_ID, MATERIA_PRIMA_ID),
    CONSTRAINT CK_COM_DETENT_CANTIDAD           CHECK (CANTIDAD_RECIBIDA > 0)
);

COMMENT ON TABLE  COM_DETALLES_ENTREGAS                         IS 'Cantidades efectivamente recibidas por insumo en cada entrega; cada registro origina una entrada en ALM_MOVIMIENTOS';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.DET_ENTREGA_ID          IS 'Identificador único del detalle de entrega';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.ENTREGA_ID              IS 'FK a la entrega a la que pertenece este detalle';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.MATERIA_PRIMA_ID        IS 'FK al insumo recibido; un insumo no puede repetirse en la misma entrega';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.CANTIDAD_RECIBIDA       IS 'Cantidad efectivamente recibida del insumo en la unidad de medida del catálogo';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.FECHA_CREACION          IS 'Fecha de registro del detalle';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.USUARIO_CREACION        IS 'Usuario que registró el detalle';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.FECHA_ACTUALIZACION     IS 'Fecha de la última modificación';
COMMENT ON COLUMN COM_DETALLES_ENTREGAS.USUARIO_ACTUALIZACION   IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO ALM - Movimientos y Alertas
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: ALM_MOVIMIENTOS
-- Descripcion: Registro cronológico de entradas y salidas de materias primas.
--              Entradas: recepciones de OC. Salidas: consumos en ordenes de prod.
-- -----------------------------------------------------------------------------
CREATE TABLE ALM_MOVIMIENTOS (
    MOVIMIENTO_ID           NUMBER(10)      NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    TIPO_MOVIMIENTO         VARCHAR2(10)    NOT NULL,
    CANTIDAD                NUMBER(12,3)    NOT NULL,
    COSTO_UNITARIO          NUMBER(10,4)    NOT NULL,
    FECHA_MOVIMIENTO        DATE            DEFAULT SYSDATE NOT NULL,
    ORDEN_PROD_ID           NUMBER(8),
    DET_ENTREGA_ID          NUMBER(10),
    REFERENCIA              VARCHAR2(100),
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_ALM_MOVIMIENTOS               PRIMARY KEY (MOVIMIENTO_ID),
    CONSTRAINT FK_ALM_MOV_MAT_PRIMAS            FOREIGN KEY (MATERIA_PRIMA_ID)  REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT FK_ALM_MOV_DET_ENTREGAS          FOREIGN KEY (DET_ENTREGA_ID)    REFERENCES COM_DETALLES_ENTREGAS(DET_ENTREGA_ID),
    CONSTRAINT CK_ALM_MOV_TIPO                  CHECK (TIPO_MOVIMIENTO IN ('ENTRADA', 'SALIDA')),
    CONSTRAINT CK_ALM_MOV_CANTIDAD              CHECK (CANTIDAD > 0),
    CONSTRAINT CK_ALM_MOV_COSTO                 CHECK (COSTO_UNITARIO >= 0),
    CONSTRAINT CK_ALM_MOV_ORIGEN                CHECK (
        (TIPO_MOVIMIENTO = 'ENTRADA' AND DET_ENTREGA_ID IS NOT NULL AND ORDEN_PROD_ID IS NULL) OR
        (TIPO_MOVIMIENTO = 'SALIDA'  AND ORDEN_PROD_ID  IS NOT NULL AND DET_ENTREGA_ID IS NULL)
    )
);

COMMENT ON TABLE  ALM_MOVIMIENTOS                           IS 'Registro cronológico de entradas y salidas; es la base del control de inventario y del cálculo de costo promedio';
COMMENT ON COLUMN ALM_MOVIMIENTOS.MOVIMIENTO_ID             IS 'Identificador único del movimiento de almacén';
COMMENT ON COLUMN ALM_MOVIMIENTOS.MATERIA_PRIMA_ID          IS 'FK al insumo afectado por este movimiento';
COMMENT ON COLUMN ALM_MOVIMIENTOS.TIPO_MOVIMIENTO           IS 'ENTRADA: recepción de compra; SALIDA: consumo en orden de producción';
COMMENT ON COLUMN ALM_MOVIMIENTOS.CANTIDAD                  IS 'Cantidad movida en la unidad de medida del insumo; siempre positiva';
COMMENT ON COLUMN ALM_MOVIMIENTOS.COSTO_UNITARIO            IS 'Costo unitario del insumo en el momento del movimiento, en soles';
COMMENT ON COLUMN ALM_MOVIMIENTOS.FECHA_MOVIMIENTO          IS 'Fecha y hora en que se realizó el movimiento físico';
COMMENT ON COLUMN ALM_MOVIMIENTOS.ORDEN_PROD_ID             IS 'FK a la OP que originó la salida; debe ser NULL si TIPO_MOVIMIENTO = ENTRADA';
COMMENT ON COLUMN ALM_MOVIMIENTOS.DET_ENTREGA_ID            IS 'FK al detalle de entrega que originó la entrada; debe ser NULL si TIPO_MOVIMIENTO = SALIDA';
COMMENT ON COLUMN ALM_MOVIMIENTOS.REFERENCIA                IS 'Referencia adicional del movimiento (número de documento, nota de despacho, etc.)';
COMMENT ON COLUMN ALM_MOVIMIENTOS.FECHA_CREACION            IS 'Fecha de registro del movimiento en el sistema';
COMMENT ON COLUMN ALM_MOVIMIENTOS.USUARIO_CREACION          IS 'Usuario que registró el movimiento';
COMMENT ON COLUMN ALM_MOVIMIENTOS.FECHA_ACTUALIZACION       IS 'Fecha de la última modificación';
COMMENT ON COLUMN ALM_MOVIMIENTOS.USUARIO_ACTUALIZACION     IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: ALM_ALERTAS_REPOSICION
-- Descripcion: Alertas generadas automáticamente por trigger cuando el stock
--              cae por debajo del nivel mínimo de seguridad
-- -----------------------------------------------------------------------------
CREATE TABLE ALM_ALERTAS_REPOSICION (
    ALERTA_ID               NUMBER(8)       NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    FECHA_ALERTA            DATE            DEFAULT SYSDATE NOT NULL,
    STOCK_AL_MOMENTO        NUMBER(12,3)    NOT NULL,
    STOCK_MINIMO            NUMBER(12,3)    NOT NULL,
    ATENDIDA                NUMBER(1)       DEFAULT 0 NOT NULL,
    FECHA_ATENCION          DATE,
    USUARIO_ATENCION        VARCHAR2(50),
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_ALM_ALERTAS_REPOSICION        PRIMARY KEY (ALERTA_ID),
    CONSTRAINT FK_ALM_ALERTAS_MAT_PRIMAS        FOREIGN KEY (MATERIA_PRIMA_ID) REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT CK_ALM_ALERTAS_ATENDIDA          CHECK (ATENDIDA IN (0, 1))
);

COMMENT ON TABLE  ALM_ALERTAS_REPOSICION                        IS 'Alertas de reposición generadas por trigger al caer el stock por debajo del mínimo; deben ser gestionadas por el área de compras';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.ALERTA_ID              IS 'Identificador único de la alerta de reposición';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.MATERIA_PRIMA_ID       IS 'FK al insumo cuyo stock bajó del nivel mínimo';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.FECHA_ALERTA           IS 'Fecha y hora en que el trigger generó la alerta';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.STOCK_AL_MOMENTO       IS 'Stock disponible del insumo en el instante en que se disparó la alerta';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.STOCK_MINIMO           IS 'Nivel de stock mínimo vigente al momento de la alerta (guardado para referencia histórica)';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.ATENDIDA               IS 'Indicador: 0=alerta pendiente, 1=alerta marcada como atendida por compras';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.FECHA_ATENCION         IS 'Fecha en que el área de compras marcó la alerta como atendida';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.USUARIO_ATENCION       IS 'Usuario que marcó la alerta como atendida';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.FECHA_CREACION         IS 'Fecha de registro de la alerta';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.USUARIO_CREACION       IS 'Usuario o proceso automático que generó la alerta';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN ALM_ALERTAS_REPOSICION.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- =============================================================================
-- MODULO PRD - PRODUCCION
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabla: PRD_ORDENES_PRODUCCION
-- Descripcion: Órdenes internas que autorizan la fabricación de un lote de calzado.
--              Registra la ficha técnica vigente al momento de su creacion.
-- -----------------------------------------------------------------------------
CREATE TABLE PRD_ORDENES_PRODUCCION (
    ORDEN_PROD_ID               NUMBER(8)       NOT NULL,
    CODIGO                      VARCHAR2(20)    NOT NULL,
    PEDIDO_ID                   NUMBER(8),
    MODELO_ID                   NUMBER(6)       NOT NULL,
    FICHA_ID                    NUMBER(8)       NOT NULL,
    FECHA_EMISION               DATE            DEFAULT SYSDATE NOT NULL,
    FECHA_INICIO_PLAN           DATE            NOT NULL,
    FECHA_ENTREGA_PLAN          DATE            NOT NULL,
    FECHA_CIERRE_REAL           DATE,
    ESTADO                      VARCHAR2(15)    DEFAULT 'PLANIFICADA' NOT NULL,
    PARES_PLANIFICADOS          NUMBER(6)       NOT NULL,
    PARES_PRODUCIDOS            NUMBER(6)       DEFAULT 0,
    OBSERVACIONES               VARCHAR2(500),
    FECHA_CREACION              DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION            VARCHAR2(50)    NOT NULL,
    FECHA_ACTUALIZACION         DATE,
    USUARIO_ACTUALIZACION       VARCHAR2(50),
    CONSTRAINT PK_PRD_ORDENES_PRODUCCION        PRIMARY KEY (ORDEN_PROD_ID),
    CONSTRAINT UQ_PRD_ORD_PROD_CODIGO           UNIQUE (CODIGO),
    CONSTRAINT FK_PRD_ORDPROD_PEDIDOS           FOREIGN KEY (PEDIDO_ID)  REFERENCES COM_PEDIDOS(PEDIDO_ID),
    CONSTRAINT FK_PRD_ORDPROD_MODELOS           FOREIGN KEY (MODELO_ID)  REFERENCES CAT_MODELOS(MODELO_ID),
    CONSTRAINT FK_PRD_ORDPROD_FICHAS            FOREIGN KEY (FICHA_ID)   REFERENCES CAT_FICHAS_TECNICAS(FICHA_ID),
    CONSTRAINT CK_PRD_ORDPROD_ESTADO            CHECK (ESTADO IN ('PLANIFICADA', 'EN_PRODUCCION', 'COMPLETADA', 'CANCELADA')),
    CONSTRAINT CK_PRD_ORDPROD_PARES_PLAN        CHECK (PARES_PLANIFICADOS > 0),
    CONSTRAINT CK_PRD_ORDPROD_PARES_PROD        CHECK (PARES_PRODUCIDOS >= 0),
    CONSTRAINT CK_PRD_ORDPROD_FECHAS            CHECK (FECHA_ENTREGA_PLAN >= FECHA_INICIO_PLAN)
);

COMMENT ON TABLE  PRD_ORDENES_PRODUCCION                        IS 'Órdenes de producción que autorizan la fabricación de un lote; la FICHA_ID queda fija al crearla para preservar el cálculo de requerimientos';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.ORDEN_PROD_ID          IS 'Identificador único interno de la orden de producción';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.CODIGO                 IS 'Código legible único asignado a la OP (ej. OP-2024-0001)';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.PEDIDO_ID              IS 'FK al pedido que originó esta OP; NULL si es producción para stock';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.MODELO_ID              IS 'FK al modelo de calzado a fabricar';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FICHA_ID               IS 'FK a la versión de ficha técnica vigente al crear la OP; no debe modificarse para preservar el requerimiento calculado';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FECHA_EMISION          IS 'Fecha en que se emitió la orden de producción';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FECHA_INICIO_PLAN      IS 'Fecha planificada de inicio de la producción del lote';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FECHA_ENTREGA_PLAN     IS 'Fecha planificada de entrega del lote terminado; debe ser igual o posterior a FECHA_INICIO_PLAN';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FECHA_CIERRE_REAL      IS 'Fecha real de cierre de la OP; se registra al pasar el estado a COMPLETADA';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.ESTADO                 IS 'Estado: PLANIFICADA, EN_PRODUCCION, COMPLETADA o CANCELADA; solo PLANIFICADA y EN_PRODUCCION aceptan salidas de almacén';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.PARES_PLANIFICADOS     IS 'Total de pares a producir (suma de cantidades de todas las tallas del detalle)';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.PARES_PRODUCIDOS       IS 'Total de pares efectivamente producidos; se actualiza al cerrar la OP';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.OBSERVACIONES          IS 'Notas adicionales sobre la orden de producción';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FECHA_CREACION         IS 'Fecha de registro de la OP';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.USUARIO_CREACION       IS 'Usuario que creó el registro';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN PRD_ORDENES_PRODUCCION.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: PRD_DETALLES_ORD_PROD
-- Descripcion: Tallas y cantidades planificadas y producidas por orden de producción
-- -----------------------------------------------------------------------------
CREATE TABLE PRD_DETALLES_ORD_PROD (
    DET_ORD_PROD_ID         NUMBER(10)      NOT NULL,
    ORDEN_PROD_ID           NUMBER(8)       NOT NULL,
    TALLA                   VARCHAR2(10)    NOT NULL,
    CANTIDAD_PLAN           NUMBER(6)       NOT NULL,
    CANTIDAD_REAL           NUMBER(6)       DEFAULT 0,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_PRD_DETALLES_ORD_PROD         PRIMARY KEY (DET_ORD_PROD_ID),
    CONSTRAINT FK_PRD_DETOP_ORDENES_PROD        FOREIGN KEY (ORDEN_PROD_ID) REFERENCES PRD_ORDENES_PRODUCCION(ORDEN_PROD_ID),
    CONSTRAINT UQ_PRD_DETOP_OP_TALLA            UNIQUE (ORDEN_PROD_ID, TALLA),
    CONSTRAINT CK_PRD_DETOP_CANT_PLAN           CHECK (CANTIDAD_PLAN > 0),
    CONSTRAINT CK_PRD_DETOP_CANT_REAL           CHECK (CANTIDAD_REAL >= 0)
);

COMMENT ON TABLE  PRD_DETALLES_ORD_PROD                         IS 'Tallas y cantidades planificadas y producidas por OP; cada OP debe tener al menos una línea de detalle';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.DET_ORD_PROD_ID         IS 'Identificador único de la línea de detalle de la OP';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.ORDEN_PROD_ID           IS 'FK a la orden de producción a la que pertenece esta línea';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.TALLA                   IS 'Talla del calzado para esta línea; una talla no puede repetirse en la misma OP';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.CANTIDAD_PLAN           IS 'Cantidad de pares planificada para esta talla; mayor a cero';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.CANTIDAD_REAL           IS 'Cantidad de pares efectivamente producidos para esta talla; se actualiza al cerrar la OP';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.FECHA_CREACION          IS 'Fecha de registro de la línea';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.USUARIO_CREACION        IS 'Usuario que registró la línea';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.FECHA_ACTUALIZACION     IS 'Fecha de la última modificación';
COMMENT ON COLUMN PRD_DETALLES_ORD_PROD.USUARIO_ACTUALIZACION   IS 'Usuario que realizó la última modificación';


-- -----------------------------------------------------------------------------
-- Tabla: PRD_REQUERIMIENTOS_MAT
-- Descripcion: Requerimiento teórico de materias primas calculado al crear la OP.
--              Ficha tecnica x pares planificados por talla. Permite comparar
--              consumo teorico vs real para calcular la merma del lote.
-- -----------------------------------------------------------------------------
CREATE TABLE PRD_REQUERIMIENTOS_MAT (
    REQUERIMIENTO_ID        NUMBER(10)      NOT NULL,
    ORDEN_PROD_ID           NUMBER(8)       NOT NULL,
    MATERIA_PRIMA_ID        NUMBER(6)       NOT NULL,
    TALLA                   VARCHAR2(10)    NOT NULL,
    CANTIDAD_TEORICA        NUMBER(12,3)    NOT NULL,
    CANTIDAD_CONSUMIDA      NUMBER(12,3)    DEFAULT 0 NOT NULL,
    FECHA_CREACION          DATE            DEFAULT SYSDATE NOT NULL,
    USUARIO_CREACION        VARCHAR2(50)    NOT NULL,
	FECHA_ACTUALIZACION     DATE,
    USUARIO_ACTUALIZACION   VARCHAR2(50),
    CONSTRAINT PK_PRD_REQUERIMIENTOS_MAT        PRIMARY KEY (REQUERIMIENTO_ID),
    CONSTRAINT FK_PRD_REQMAT_ORDENES_PROD       FOREIGN KEY (ORDEN_PROD_ID)     REFERENCES PRD_ORDENES_PRODUCCION(ORDEN_PROD_ID),
    CONSTRAINT FK_PRD_REQMAT_MAT_PRIMAS         FOREIGN KEY (MATERIA_PRIMA_ID)  REFERENCES ALM_MATERIAS_PRIMAS(MATERIA_PRIMA_ID),
    CONSTRAINT UQ_PRD_REQMAT_OP_MAT_TALL        UNIQUE (ORDEN_PROD_ID, MATERIA_PRIMA_ID, TALLA),
    CONSTRAINT CK_PRD_REQMAT_CANT_TEOR          CHECK (CANTIDAD_TEORICA > 0),
    CONSTRAINT CK_PRD_REQMAT_CANT_CONS          CHECK (CANTIDAD_CONSUMIDA >= 0)
);

COMMENT ON TABLE  PRD_REQUERIMIENTOS_MAT                        IS 'Requerimiento teórico de insumos por OP y talla; calculado al crear la OP como ficha técnica x pares planificados';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.REQUERIMIENTO_ID       IS 'Identificador único del requerimiento teórico';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.ORDEN_PROD_ID          IS 'FK a la orden de producción a la que pertenece este requerimiento';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.MATERIA_PRIMA_ID       IS 'FK al insumo requerido según la ficha técnica';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.TALLA                  IS 'Talla a la que corresponde este requerimiento de insumo';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.CANTIDAD_TEORICA       IS 'Cantidad teórica: CANTIDAD_POR_PAR de la ficha x CANTIDAD_PLAN de la talla en la OP';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.CANTIDAD_CONSUMIDA     IS 'Cantidad efectivamente consumida registrada mediante salidas de almacén; la diferencia con CANTIDAD_TEORICA es la merma';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.FECHA_CREACION         IS 'Fecha en que se generó el requerimiento (al crear la OP)';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.USUARIO_CREACION       IS 'Usuario o proceso que generó el requerimiento';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.FECHA_ACTUALIZACION    IS 'Fecha de la última modificación';
COMMENT ON COLUMN PRD_REQUERIMIENTOS_MAT.USUARIO_ACTUALIZACION  IS 'Usuario que realizó la última modificación';


-- FK diferida: ALM_MOVIMIENTOS -> PRD_ORDENES_PRODUCCION
-- Se agrega aqui porque PRD_ORDENES_PRODUCCION se crea despues de ALM_MOVIMIENTOS
ALTER TABLE ALM_MOVIMIENTOS
    ADD CONSTRAINT FK_ALM_MOV_ORDENES_PROD
    FOREIGN KEY (ORDEN_PROD_ID) REFERENCES PRD_ORDENES_PRODUCCION(ORDEN_PROD_ID);



