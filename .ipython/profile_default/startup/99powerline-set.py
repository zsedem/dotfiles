try:
    import powerline
except ImportError:
    pass
else:
    get_ipython().extension_manager.load_extension('powerline.bindings.ipython.post_0_11')

