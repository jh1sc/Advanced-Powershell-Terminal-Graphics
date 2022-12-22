Add-Type -AssemblyName  Microsoft.VisualBasic, PresentationCore, PresentationFramework, System.Drawing, System.Windows.Forms, WindowsBase, WindowsFormsIntegration, System



function SetupConsole
{
    param([int]$x, [int]$y)
    try {
        $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($x,$y)
        $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size($x,$y)
        $screen = @(" " * $host.UI.RawUI.BufferSize.Width) * $host.UI.RawUI.BufferSize.Height
    }
    catch {
        $err = $_.Exception.Message
        [System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')
    }
}

function Setgrid 
{
    param([int]$x, [int]$y)
    try {$screen = @(" " * $host.UI.RawUI.BufferSize.Width) * $host.UI.RawUI.BufferSize.Height}
    catch {$err = $_.Exception.Message;[System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')}
}


Function BufferWrite 
{
    param ([string]$String)
    [console]::setcursorposition(0,0)
    try {
        $Bytes = $String.ToCharArray() -as [byte[]]
        $OutStream = [console]::OpenStandardOutput()
        $OutStream.Write($Bytes,0,$Bytes.Length)
    }
    catch {
        $err = $_.Exception.Message
        [System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')
    }
}
 

#buffer size
function SetBuffer 
{
    param([int]$x, [int]$y)
    try{$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size($x,$y)}
    catch {$err = $_.Exception.Message;[System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')}
}

#window size
function SetWindow 
{
    param([int]$x, [int]$y)
    try{$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($x,$y)}
    catch {$err = $_.Exception.Message;[System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')}
}

#pixel
function Pixel 
{
    param([int]$x, [int]$y, [string]$o)
    if ($screen -eq $null) {$screen = @(" " * $host.UI.RawUI.BufferSize.Width) * $host.UI.RawUI.BufferSize.Height}
    try{$screen[$y] = $screen[$y].substring(0,$x) + $o + $screen[$y].substring($x+1)}
    catch {$err = $_.Exception.Message;[System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')}
}

#clear screen
function ClearScreen 
{
    try{$screen = @(" " * $host.UI.RawUI.BufferSize.Width) * $host.UI.RawUI.BufferSize.Height}
    catch {$err = $_.Exception.Message;[System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')}
}

#window title
function title 
{
    param([string]$title)
    try{$host.UI.RawUI.WindowTitle = $title}
    catch {$err = $_.Exception.Message;[System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')}
}


#A-sync Key State return true or false
function ASKS {
	param ([string]$Char)
	Add-Type -AssemblyName System.Windows.Forms
	
	$signature = 
@"
	[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
	public static extern short GetAsyncKeyState(int virtualKeyCode);
"@
try {
    $GetAsyncKeyState = Add-Type -MemberDefinition $signature -Name "Win32GetAsyncKeyState" -Namespace Win32Functions -PassThru
    return $GetAsyncKeyState::GetAsyncKeyState([System.Windows.Forms.Keys]::$Char)
}
catch {
    $err = $_.Exception.Message
    [System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')
}
}

#Convert mouse to game
function MouseToConsole
{
    param([int]$x, [int]$y)
    try{
        $mousepos = [System.Windows.Forms.Cursor]::Position
        $mx = [int]($mousepos.x * ($host.UI.RawUI.BufferSize.Width / [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width))
        $my = [int]($mousepos.y * ($host.UI.RawUI.BufferSize.Height / [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height))
        [pscustomobject]@{x=$mx;y=$my}
        return $mx, $my
    }
    catch {
        $err = $_.Exception.Message
        [System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')
    }
}

#2d line
function Line2D {
	param ([int]$x1, [int]$y1, [int]$x2, [int]$y2, [string]$o)
	$dx = $x2 - $x1
	$dy = $y2 - $y1
	$steps = [math]::Max([math]::Abs($dx),[math]::Abs($dy))
	$xinc = $dx / $steps
	$yinc = $dy / $steps
	$x = $x1
	$y = $y1
	for ($i=0; $i -le $steps; $i++) {
		Pixel $x $y $o
		$x += $xinc
		$y += $yinc
	}
}

function DrawTriangle 
{
	param ([int]$x1, [int]$y1, [int]$x2, [int]$y2, [int]$x3, [int]$y3, [string]$o)
    try {
        Line2D $x1 $y1 $x2 $y2 $o
        Line2D $x2 $y2 $x3 $y3 $o
        Line2D $x3 $y3 $x1 $y1 $o
    }
    catch {
        $err = $_.Exception.Message
        [System.Windows.MessageBox]::Show($err, 'APTG - Error', 'Ok','Error')
    }
}



