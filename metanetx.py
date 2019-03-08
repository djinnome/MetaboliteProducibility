import pandas as pd

def convert_db(fromdb, todb,chemxref='https://www.metanetx.org/cgi-bin/mnxget/mnxref/chem_xref.tsv' ):
    if type(chemxref) is str:
        chemxref = pd.read_csv(chemxref,sep='\t',comment='#',   names='XREF	MNX_ID	Evidence	Description'.split('\t'))
    fromxref = chemxref[chemxref['XREF'].str.contains(fromdb + ':')]
    fromcol = fromxref['XREF'].str.split(':',expand=True)[1].copy()
    fromxref.loc[:,fromdb] = fromcol
    toxref = chemxref[chemxref['XREF'].str.contains(todb + ':')]
    tocol = toxref['XREF'].str.split(':',expand=True)[1].copy()
    toxref.loc[:,todb] = tocol
    return fromxref.merge(toxref, how='inner', on='MNX_ID',suffixes=(':'+fromdb, ':'+todb))
