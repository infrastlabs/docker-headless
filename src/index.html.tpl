<style type='text/css'>
body{
    background-color: #636a63;
}
.main{
    background-color: #fff;
    border-radius: 20px;
    width: 300px;
    height: 450px;
    margin: auto;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
}
</style>
<script type="text/javascript">
function openVnc(token, vnctype){
    var pass=document.getElementById('password').value;
    window.open("/"+vnctype+".html?path=websockify/?token="+token+"&autoconnect=true&password="+pass);
    // console.log("/vnc.html?path=websockify/?token=display10&password=");
}
</script>
<body>
<div class="main">
    <div style="margin-top: 8px; margin-left: 22px;">
        VNC_PASS: <input type="password" id="password" maxlength="20" value="headless"/>
    </div>
    <ul style="margin-top: 8px;">
        <!-- <li><a href="javascript:void(0);" onclick="openVnc('display10')">display0</a></li> -->
        <!-- <li><a target="_blank" href="/vnc.html?path=websockify/?token=display10&password=xx">display0</a></li>
        <li><a target="_blank" href="/vnc_lite.html?path=websockify/?token=display10&password=xx">display0-lite</a></li>
        <li></li>
    </ul>
</div>
</body> -->
