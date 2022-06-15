<?
$name= $_POST["name"];
$feedback = stripslashes($_POST["feedback"]);
$arrival = $_POST["arrival"];
$departure = $_POST["departure"];
$plaque = $_POST["timesLoadedPlaque"];

if (!empty($_SERVER['HTTP_CLIENT_IP']))   //check ip from share internet
{
	$ip=$_SERVER['HTTP_CLIENT_IP'];
}
elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))   //to check ip is pass from proxy
{
	$ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
}
else
{
	$ip=$_SERVER['REMOTE_ADDR'];
}

$date = date(DATE_ATOM);
$file = "./feedback/$name@$date@$ip.txt";

// Write the contents back to the file
// $file_put_results = file_put_contents($file, $feedback);

$contents = "Name: " . $name . "\n" . "Arrived: " . $arrival . "\n" . "Departed: " . $departure . "\n";
$contents = $contents . "Plaque loaded " . $plaque . " times." . "\n\n";
$contents = $contents . "Feedback:\n" . $feedback;

$file_put_results = file_put_contents($file, $contents);

echo $file_put_results;
?>