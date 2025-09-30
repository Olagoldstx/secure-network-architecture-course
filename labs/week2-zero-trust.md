## VPC Diagram

```mermaid
%%{init: {'theme': 'neutral'}}%%
flowchart LR
  AppA --> TGW
  AppB --> TGW
  TGW --> SharedSvcs
```
