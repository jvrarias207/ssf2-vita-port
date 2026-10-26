// Native, renderer-independent regression checks; also compiled into Vita startup.
#include "recovery-checks.h"
#include "ground-attack-checks.h"
#include "aerial-checks.h"
#include "movement-checks.h"
#include "action-checks.h"
#include "extended-checks.h"
#include "ai-checks.h"
#include "protection-checks.h"
#include "pcm-checks.h"
int main(){
 int failures=runRecoveryChecks(stdout);
 failures+=runGroundAttackChecks(stdout);
 failures+=runAerialChecks(stdout);
 failures+=runMovementChecks(stdout);
 failures+=runActionChecks(stdout);
 failures+=runExtendedChecks(stdout);
 failures+=runAiChecks(stdout);
 failures+=runProtectionChecks(stdout);
 failures+=runPcmChecks(stdout);
 fprintf(stdout,"Total failures: %d\n",failures);
 return failures?1:0;
}
