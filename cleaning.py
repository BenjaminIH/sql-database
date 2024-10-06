import pandas as pd
import geopandas as gpd
import pycountry
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import numpy as np
from dotenv import load_dotenv
import os
import seaborn as sns



def world_plot(df, llabel):
    # Load world shape data from geopandas
    world = gpd.read_file('maps/110m_cultural/ne_110m_admin_0_countries.shp')
    df2 = df.copy()
    df2["code"] = df2["code"].replace({"FRA":"FR1" , "NZL":"NZ1" , "FIN":"FI1" , "DNK":"DN1" , "CHN":"CH1" , "GBR":"GB1" , "USA":"US1" , "AUS":"AU1" , "NDL":"NL1" , "CUB":"CU1" , "KAZ":"KA1" , "SSD":"SDS" , "ESH":"SAH" , "ISR":"IS1"})
    
    # Merge with the world GeoDataFrame
    m1 = world.merge(df2, how='left', left_on='SOV_A3', right_on='code')

    # Define a custom colormap without white
    colors = ['#1dbf1d', '#e30f0b'] 
    custom_cmap = mcolors.LinearSegmentedColormap.from_list("custom_reds", colors)

    # Plot the map with filled shapes
    fig, ax = plt.subplots(1, 1, figsize=(20, 10))

    # Plot the countries with data using the custom colormap
    m1.plot(column='score', cmap=custom_cmap, legend=False, ax=ax, missing_kwds={'color': 'darkgrey'})

    # Create a colorbar
    sm = plt.cm.ScalarMappable(cmap=custom_cmap, norm=plt.Normalize(vmin=m1['score'].min(), vmax=m1['score'].max()))
    sm.set_array([])  # Needed for older versions of matplotlib
    plt.colorbar(sm, ax=ax, label=llabel)

    # Set title and remove axis
    ax.axis('off')
    plt.title(f'World Map by {llabel}')
    plt.show()
    
# Function to get the 3-letter country code
def get_country_code(country_name):
    try:
        return pycountry.countries.lookup(country_name).alpha_3
    except LookupError:
        return None
    
# display energy graphics
def graph_melt(df, title):
    df_melted = df.melt(id_vars='country', 
                    value_vars=['avg_biofuel', 'avg_coal', 'avg_hydro', 'avg_gas', 
                                'avg_nuclear', 'avg_oil', 'avg_solar', 'avg_wind'],
                    var_name='Energy Source', 
                    value_name='Average Value')

    threshold = 2  # Set your threshold value
    df_filtered = df_melted[df_melted['Average Value'] >= threshold]

    sns.barplot(data=df_filtered, x='country', y='Average Value', hue='Energy Source')

    plt.title(title)
    plt.xlabel('Country')
    plt.ylabel('Average Value (%)')
    plt.xticks(rotation=45)
    plt.legend(title=title, bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)

    # Show the plot
    plt.tight_layout()
    plt.show()
    

def export_sql(df, engine,  columns_list, table_name):
    df = df[columns_list]
    df.to_sql(name=table_name, con=engine, if_exists='replace', index=False)
    
def import_csv(filename):
    return pd.read_csv('sources/' + filename)

def rename_columns(df, new_names_dict):
    df = df.rename(new_names_dict, axis=1)
    return df

def clean_owid_data(schema) -> pd.DataFrame:
    columns = {column_info["originalName"]: column_name 
               for column_name, column_info in schema["columns"].items()}
    df = import_csv(schema['filename'])
    df = rename_columns(df, columns)
    df = clean_column_names(df)
    return df
    
def get_latest_year_data(df, group_column, year_column = 'year'):
    df_latest = df.loc[df.groupby('country')['year'].idxmax()]
    df_latest = drop_nan_values(df_latest)
    return df_latest

def drop_nan_values(df):
    df = df.dropna()
    return df

def export_csv(df, file_name):
    df.to_csv(file_name, index=False)
    
def clean_column_names(df):
    df.columns = df.columns.str.lower().str.replace(' ', '_')
    return df
