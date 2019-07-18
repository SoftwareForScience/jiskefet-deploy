# Single node O²/FLP software deployment

## Prerequisites

The machine executing the installation script is required to have ansible and git installed.

```
yum -y install ansible git
```

If you want to open InfoBrowser on a CERN Cloud target machine, make sure to use the -X option when ssh'ing.

## Quickstart

A convenience script is provided to automate single node deployments.
Usage:
```
git clone https://gitlab.cern.ch/AliceO2Group/system-configuration.git
cd system-configuration/ansible/utils
./o2-install-flp-standalone <your target hostname> <target username (usually root)>
```

**Important**: for the time being, the only supported user is **`root`**.
For example, to deploy on the host `my-flp-machine`, the command would be
```
./o2-install-flp-standalone my-flp-machine root
```

This will take a while, usually between 10 and 30 minutes depending on circumstances.

## Quick Guide: Accessing the web-based GUIs

Once the installation finishes, a list of the available web-based GUIs can be found in the target machine (e.g. `http://localhost`).
It includes links to several GUIs for Control, Logging, QC and Monitoring. 

## Quick Guide: Using AliECS

The AliECS core and GUI are always running by default (systemd units `o2-aliecs-core` and `cog`).

To access the AliECS GUI, go to the index webpage (e.g. `http://localhost`).

A single-node workflow `readout-1` will be listed under **Workflows** in the left side menu. This workflow is provided in the default configuration, and it can be started as a new environment, which then offers START/STOP/CONFIGURE/RESET buttons.

To start a new environment with the workflow `readout-1`:

1) make sure you have the lock (the **lock** icon in the top-left corner must be green, if not, click it);
2) go to **Environments** and then click the **+** button in the top-right corner of the page;
3) select `readout-1` in the drop-down box and click on **Create**.

A page shows up with the overview of the newly started environment. You can then use the buttons at the top (section **Control**) to drive the state machine of the environment.

## Quick Guide: ReadoutCard configuration and Hugepages

The `flp-readoutcard` portion of the script will set up hugepage allocation on boot through the `roc_hugepages_config` systemd
service. By default 6 * 1GB and 128 * 2MB hugepages will be allocated. To change the number of hugepages:

1) Edit `/etc/flp.d/readoutcard/hugepages-1GiB.conf` and `/etc/flp.d/readoutcard/hugepages-2MiB.conf` accordingly.
2) Restart the systemd service by running `systemctl restart roc_hugepages_config.service`.

## Quick Guide: Readout configuration

The default configuration file for the `readout.exe` binary is installed in `/home/flp/readout.cfg`.

It instantiates a HugePages memory bank, a dummy equipment generating random data, and connection to monitoring.
It also includes disabled examples for CRU equipment and file recording.

More examples can be found in the Readout installation directory (`/opt/alisw/el7/Readout/vX.Y.Z/etc/`).
For information on how to modify this configuration for your purposes, see the [Readout documentation](https://github.com/AliceO2Group/Readout/blob/master/doc/README.md#configuration) and the [Readout configuration parameters reference](https://github.com/AliceO2Group/Readout/blob/master/doc/configurationParameters.md).

## Quick guide: Using infoLogger

After the FLP standalone install, browse the log messages with:
  - Web application called InfoLogger GUI: open the index webpage (e.g. `http://localhost`)
  - Desktop application called infoBrowser (requires X11): `/opt/o2-InfoLogger/bin/infoBrowser &`.

When started, it connects immediately to the server collecting logs ('online' mode).
You can test the logging system by adding a message from the command line with e.g. `/opt/o2-InfoLogger/bin/log "This is a test message"`.
It should appear in the infoBrowser or InfoLogger GUI.
You can query archived messages:
  - InfoLogger GUI: Just click "Query" button
  - infoBrowser: by exiting the online mode clicking the green 'online' button, and then press the 'query' button.

Further information about infoLogger can be found in the [InfoLogger documentation](https://github.com/AliceO2Group/InfoLogger/blob/master/doc/README.md) and in the [InfoLogger GUI README](https://github.com/AliceO2Group/WebUi/tree/dev/InfoLogger).

## Quick guide: Using monitoring

Monitoring module collects, stores and visualises metrics:
 - Readout and CRU
 - system performance.

Open the index webpage (e.g. `http://localhost`) and click on the Monitoring section links in order to access the visualisation application called Grafana. Then, select one of the available dashboards.

In addition, Monitoring module extends the AliECS GUI, providing Readout values (bytes read since startup, current readout rate) and a plot (readout rate) embedded into the environment details page.

## Quick Guide: Using and configuring QualityControl 

We use AliECS for this exercise. To start the workflow `readout->QC` do:

0. Open the index webpage (e.g. `http://localhost`) and click on the AliECS GUI link. 
1. Make sure you have the lock (the **lock** icon in the top-left corner must be green, if not, click it);
2. Go to **Environments** and then click the **+** button in the top-right corner of the page;
3. Select `readout-qc-1` in the drop-down box and click on **Create**.
4. In the page that shows up with the overview of the newly started environment, use the buttons at the top to start the workflow. 

To see the objects published by the QC do:
1. Open the index webpage (e.g. `http://localhost`) and click on the Quality Control GUI link. 
2. Click on the "Online" button at the top;
3. Open the tree in the right panel and select the object you want to display. 

The default configuration files for the QC are installed in `/etc/flp.d/qc`. We ship two configuration files:
1. basic.json - used by the workflow o2-qc-run-basic
2. readout.json - used by the workflow o2-qc-run-readout.
In the workflow launched above, we use the one named `readout.json`. One will typically want to modify the `className` and `moduleName` to use their detector's plugin.  

TODO : how to restart the task after a change of configuration ? 

Please do note that only modules who have been released along with a the QC Framework are available. A solution to run your modules under development is being considered.

More information about QC and its configuration can be found in the documentation hosted in the [QualityControl repo](https://github.com/AliceO2Group/QualityControl) on GitHub. 

## Troubleshooting

### Running behind an HTTP proxy server

When deploying in the O² FLP lab in CERN building 4, the previous command must be modified to also pass the proxy settings:
```
ANSIBLE_HTTP_PROXY="http://10.163.32.14:8080" ANSIBLE_HTTPS_PROXY="http://10.163.32.14:8080" ./o2-install-flp-standalone <your target hostname> <target username (usually root)>
```

Proxy settings should be adapted based on the previous example if your setup requires a proxy server.

### devtoolset-7 and privilege escalation prompt error

When running the script for a user, for which `devtoolset-7` is sourced, [this](https://github.com/ansible/ansible/issues/14426) ansible error occurs. To bypass this make sure to
remove the relevant source command, usually in `.bashrc` or `.bash_profile`, and reload the shell before executing the script.

Examples of commands that may trigger this:
```
./o2-install-flp-standalone flp-host
./o2-install-flp-standalone flp-host someuser
```

### AliECS

To check the status of the core and GUI, run the following commands:
```
systemctl status o2-aliecs-core
systemctl status cog
```

If one or both are not running for some reason, they can be started manually as follows:
```
systemctl start o2-aliecs-core
systemctl start cog
```

The GUI should connect to the core within a few seconds. If needed, the GUI can be restarted with `systemctl restart cog`.

All systemctl commands for `o2-aliecs-core` and `cog` (`stop`, `restart`, `status`) work as expected, and the logs are accessible through `journalctl` (e.g. `journalctl -u o2-aliecs-core`).

If you encounter issues, please make sure the following systemd units are running:
* `mesos-master`
* `mesos-slave`
* `o2-aliecs-core`
* `cog`

It is also possible to directly start the AliECS core without systemd. Like so:
```
source /etc/profile.d/modules.sh && MODULEPATH=/opt/alisw/el7/modulefiles module load Control-Core/v0.8.1-1 && /opt/alisw/el7/Control-Core/v0.8.1-1/bin/o2control-core --coreConfigurationUri file:///etc/aliecs.d/settings.yaml
```

**Important**: Due to a known issue, if the workflow goes into `ERROR`, there might be stale instances of Readout left running. To clean up:
```
pkill -9 -f o2control-executor
```

`coconut`, the O²/FLP **co**ntrol and **con**figuration **ut**ility is included in the deployment. Usage:
```
module load coconut
coconut info
```

For more information on `coconut`, see [the documentation](https://github.com/AliceO2Group/Control/blob/master/coconut/README.md).
