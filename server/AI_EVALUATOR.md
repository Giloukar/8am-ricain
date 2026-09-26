# Server-side AI evaluator (deployment target)

The public GitHub Pages site cannot safely contain an OpenAI secret key.
Deploy this endpoint on a serverless host and set OPENAI_API_KEY there.

Input:
{"word":"sagace","reference":"Qui comprend rapidement et avec finesse.","answer":"quelqu'un de très perspicace"}

Expected output:
{"score":0|1|2,"feedback":"court retour en français"}

Security requirements:
- rate limit by user/IP
- authenticated user when cloud accounts are enabled
- max answer length
- Structured Outputs / JSON schema
- never expose OPENAI_API_KEY to browser
- store only score/exercise timing in lexi_reviews unless user explicitly opts into storing answer text
