import hudson.model.*
import hudson.model.ParametersAction
import hudson.model.StringParameterValue
import hudson.tasks.Shell
import hudson.cli.CreateNodeCommand

ParametersAction action = build.getAction(ParametersAction.class)
StringParameterValue spv = action.getParameters()[0]
def user_choice_sha = spv.getValue()
def sha = build.getEnvVars()["GIT_COMMIT"].substring(0,7)
if(user_choice_sha != 'HEAD'){
  sha = user_choice_sha.substring(0,7)
}
println('Proceeding with SHA : ' + sha)

def sout = new StringBuffer(), serr = new StringBuffer()
def ipaddr = '192.168.1.141'
def cmd = '/bin/sh run.sh ' + sha + ' ' + ipaddr
def proc = cmd.execute(null, new File("/var/lib/jenkins/workspace/local-dev-env-trigger-manual"))

proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)
println sout
