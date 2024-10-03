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
    df["code"] = df["code"].replace({"FRA":"FR1" , "NZL":"NZ1" , "FIN":"FI1" , "DNK":"DN1" , "CHN":"CH1" , "GBR":"GB1" , "USA":"US1" , "AUS":"AU1" , "NDL":"NL1" , "CUB":"CU1" , "KAZ":"KA1" , "SSD":"SDS" , "ESH":"SAH" , "ISR":"IS1"})
    
    # Merge with the world GeoDataFrame
    m1 = world.merge(df, how='left', left_on='SOV_A3', right_on='code')

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