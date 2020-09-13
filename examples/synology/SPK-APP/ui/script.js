// basic js code: show and hide functions for sections in intro html
function showQuickStSection() {
	document.getElementById('frmQst').style.display = "block";
	document.getElementById('frmArc').style.display = "none";
	document.getElementById('frmFaq').style.display = "none";
	document.getElementById('frmChg').style.display = "none";
}
function showArchSection() {
	document.getElementById('frmQst').style.display = "none";
	document.getElementById('frmArc').style.display = "block";
	document.getElementById('frmFaq').style.display = "none";
	document.getElementById('frmChg').style.display = "none";
}
function showFaqSection() {
	document.getElementById('frmQst').style.display = "none";
	document.getElementById('frmArc').style.display = "none";
	document.getElementById('frmFaq').style.display = "block";
	document.getElementById('frmChg').style.display = "none";
}
function showChgSection() {
	document.getElementById('frmQst').style.display = "none";
	document.getElementById('frmArc').style.display = "none";
	document.getElementById('frmFaq').style.display = "none";
	document.getElementById('frmChg').style.display = "block";
}

// ext-3 js code section
function estimateHeight() {
	var myWidth = 0, myHeight = 0;
	if( typeof( window.innerWidth ) == 'number' ) {
		//Non-IE
		myHeight = window.innerHeight;
	} else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
		//IE 6+ in 'standards compliant mode'
		myHeight = document.documentElement.clientHeight;
	} else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
		//IE 4 compatible
		myHeight = document.body.clientHeight;
	}
	return myHeight;
}
	
Ext.onReady(function() {

	var conn = new Ext.data.Connection();

    function onIntroBtnClick(item){
    	textd.show();
    	texta.hide();
			conn.request({
				url: 'gethtml.cgi?'+Ext.urlEncode({action: 'intro'}),
				success: function(responseObject) {
					textd.setValue(responseObject.responseText);
				}
			});
	}

    function onSaveBtnClick(item){
		conn.request({
			url: 'writefile.cgi',
			params: Ext.urlEncode({name: fileCmb.value, action: texta.getValue()}),
			success: function(responseObject) {
				if (responseObject.responseText=="ok\n") {
					Ext.Msg.alert('Status','Changes&nbsp;saved.');
				} else {
					Ext.Msg.alert('Status',responseObject.responseText);
				}

				saveBtn.disable();
				repairBtn.enable();
			}
		});
	}
	
    function onRepairBtnClick(item){
		if (!(saveBtn.disabled)) {
			Ext.MessageBox.show({
				title: 'Warning',
				msg: 'Unsaved changes, are you sure you want to load original file?',
				icon: Ext.MessageBox.WARNING,
				buttons: Ext.MessageBox.YESNOCANCEL,
				fn: function(btn, text) {
					if (btn=='yes') {
						conn.request({
							url: 'getfile.cgi?'+Ext.urlEncode({action: fileCmb.value})+'.original',
							success: function(responseObject) {
								texta.setValue(responseObject.responseText);
							}
						});
						repairBtn.enable();
						saveBtn.enable();
					}
				}
			})
		} else {
			conn.request({
				url: 'getfile.cgi?'+Ext.urlEncode({action: fileCmb.value})+'.original',
				success: function(responseObject) {
					texta.setValue(responseObject.responseText);
				}
			});
			repairBtn.enable();
			saveBtn.enable();
		}

	}

    function onRunBtnClick(item){
    	var bgmode = '';
     	textd.hide();
     	texta.show();
    	texta.setReadOnly(true);
	   	texta.setValue('Waiting for reply of jitsi-cli '+cmdTxt.value+' (none could be ajax time-out)..');
	   	// when refresh is requested switch to bgmode
	   	if( cmdTxt.value == 'refresh' ) {
	   		bgmode = 'bg';
	   	}
		conn.request({
			//url: 'runcmd.cgi?'+Ext.urlEncode({cmd: 'jitsi-cli'})+'&'+Ext.urlEncode({action: cmdTxt.value}),
			url: 'runcmd.cgi',
			params: Ext.urlEncode({cmd: 'jitsi-cli', mode: bgmode, action: cmdTxt.value}),
			success: function(responseObject) {
				texta.setValue(responseObject.responseText);
			}
		});
		// clear cmdText at health init load event
	   	if( cmdTxt.value == 'health init' ) {
			cmdTxt.setValue('');
	   	}
		repairBtn.disable();
		saveBtn.disable();
	}

    function onFileCmbClick(item){
    	textd.hide();
    	texta.show();
    	texta.setReadOnly(false);
		conn.request({
			url: 'getfile.cgi?'+Ext.urlEncode({action: fileCmb.value}),
			success: function(responseObject) {
				texta.setValue(responseObject.responseText);
			}
		});
		repairBtn.enable();
		saveBtn.disable();
	}

	var texta = new Ext.form.TextArea ({
		hideLabel: true,
		name: 'msg',
		style: 'font-family:monospace',
		grow: false,
		preventScrollbars: false,
		anchor: '100% -53',
		enableKeyEvents:true,
		listeners: {
			keypress: function(f, e) {
				if (saveBtn.disabled) {
					saveBtn.enable();
				}
			}
		}

	});

	var textd = new Ext.form.DisplayField ({
		hideLabel: true,
		name: 'disp',
		autoScroll : true,
		htmlEncode: false
	});

	var fileCmb = new Ext.form.ComboBox ({
		store: [==:names:==],
	    width: 170,
		name: 'file',
		shadow: true,
		editable: false,
		mode: 'local',
		triggerAction: 'all',
		emptyText: 'Choose config file',
		selectOnFocus: true
	});

	var cmdTxt = new Ext.form.TextField ({
	    width: 260,
	    height: 20,
		name: 'command',
		shadow: true,
		editable: true,
		mode: 'local',
		triggerAction: 'all',
		emptyText: 'Paramater for jitsi-cli'
	});

	var introBtn = new Ext.Toolbar.Button({
		handler: onIntroBtnClick,
		name: 'intro',
		text: 'Intro',
		icon: 'images/info.png',
		cls: 'x-btn-text-icon',
		disabled: false
	});

	var saveBtn = new Ext.Toolbar.Button({
		handler: onSaveBtnClick,
		name: 'save',
		text: 'Save',
		icon: 'images/save.png',
		cls: 'x-btn-text-icon',
		disabled: true
	});

	var repairBtn = new Ext.Toolbar.Button({
		handler: onRepairBtnClick,
		name: 'original',
		text: 'Original',
		icon: 'images/source.png',
		cls: 'x-btn-text-icon',
		disabled: true
	});

	var runBtn = new Ext.Toolbar.Button({
		handler: onRunBtnClick,
		name: 'run',
		id: 'runbtn',
		text: 'Run',
		icon: 'images/run.png',
		cls: 'x-btn-text-icon',
		disabled: false
	});

    var form = new Ext.form.FormPanel({
    	renderTo: 'content',
        baseCls: 'x-plain',
        url:'save-form.php',
		height: estimateHeight(),
        items: [
			new Ext.Toolbar({
				items: [
					'-',
					introBtn,
					'-',
					saveBtn,
					'-',
					repairBtn,
					'-',
					fileCmb,
					'-',
					runBtn,
					'-',
					cmdTxt
				]
			}),
			texta,
			textd
		]
    });

	Ext.EventManager.onWindowResize(function() {
		form.doLayout();
		form.setHeight(estimateHeight());
	});

	fileCmb.addListener('select',onFileCmbClick);
	
	// init actions when UI is loaded: click runBtn with health init
	cmdTxt.setValue('health init');
	Ext.get('runbtn').dom.click();
});
