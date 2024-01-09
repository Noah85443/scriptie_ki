from osgeo import ogr

# Open GeoJSON file
geojson_file = 'path/to/your/file.geojson'
geojson_ds = ogr.Open(geojson_file)

# Create XML output~
xml_file = 'path/to/your/output.xml'
xml_ds = ogr.GetDriverByName('XML').CreateDataSource(xml_file)

# Copy layers from GeoJSON to XML
for layer_idx in range(geojson_ds.GetLayerCount()):
    layer = geojson_ds.GetLayerByIndex(layer_idx)
    xml_layer = xml_ds.CreateLayer(layer.GetName(), geom_type=layer.GetGeomType())

    for feature in layer:
        xml_layer.CreateFeature(feature)

# Close datasets
geojson_ds = None
xml_ds = None
