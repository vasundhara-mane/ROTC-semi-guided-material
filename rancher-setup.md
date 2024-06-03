
<h1>Prerequisites for the ROTC training:  Rancher desktop setup and troubleshooting guide</h1>

Rancher Desktop is a free, open-source application that brings Kubernetes, a container orchestration platform, to your desktop computer. It bundles popular open-source tools like Docker or nerdctl for building and running containers, kubectl for interacting with your Kubernetes cluster, and Helm for managing containerized applications. 

Installing Rancher Desktop can be done with a simple click and drag.

1. Navigate to https://rancherdesktop.io/ and download the dmg file for your operating system.
2. Drag the file into your applications folder
3. Test the installation: `kubectl version`

You should see the version of the client and the server version as shown here:
![Display version of kubernetes and server version](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/what-you-should-see.png)

4. In some cases the server version may be missing: 
![Showing image of server not found](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/verify-installation.png)

5. Let’s examine the configuration to see the "contexts". Contexts define how kubectl interacts with a specific Kubernetes cluster. Each context specifies details like the server address, cluster name, user credentials, and namespace. We’ll run `kubectl config get-contexts`, to see all the contexts we have configured for different Kubernetes environments. The `*` indicates which is your active context. It shows I'm running kubernetes through Colima.  
![showing get-context and colima](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/colima-context.png)

6. Shut it down, as shown below. Rerun the config get-contexts and you should now see the option of rancher-desktop.
```shell
colima stop
kubectl config get-contexts
```
  7. If rancher-desktop is not our active context, we need to change that with the following command

```shell
kubectl config use-context rancher-desktop
```
Our installation will now point to the rancher desktop. And when we run the command kubectl version it will correctly demonstrate a Client and a Server Version. 
![showing use-context in the CLI](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/use-context.png)

8. During your set up, you may also find an error about symlink:
![showing Rancher desktop diagnostics with symlin problems](https://github.com/twlabs/ROTC-semi-guided-material/blob/main/images/Symlink-error.png)

This means the docker-buildx symlink in Rancher Desktop is pointing to the wrong location. You can fix this by removing the symlink 
```shell
rm ~/.docker/cli-plugins/docker-buildx
```
Upon restarting Rancher desktop it will automatically recreate the correct symlink on restart. 
![showing Rancher desktop diagnostics without problems](https://github.com/twlabs/ROTC-semi-guided-material/blob/main/images/diagnostics.png)

<h3>Now you are ready for the Rise of The Containers Workshop!</h3>
 
