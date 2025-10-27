import json, os, urllib.request, boto3

sm = boto3.client("secretsmanager")

def handler(event, ctx):
    name = os.environ["SLACK_SECRET_NAME"]  # e.g. /mini-prod/slack/webhook
    sec  = sm.get_secret_value(SecretId=name)["SecretString"]
    try:
        url = json.loads(sec)["url"]
    except Exception:
        url = sec

    msgs = []
    for rec in event.get("Records", []):
        m = rec.get("Sns", {}).get("Message", "")
        msgs.append(m)
    text = "\n".join(msgs) if msgs else "(no message)"

    payload = {"text": f":rotating_light: {text}"}
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req) as r:
        r.read()
    return {"ok": True}
