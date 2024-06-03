
Setting up Rancher is can be done with a simple click.

1. Navigate to https://rancherdesktop.io/ and download the dmg file for your operating system.
2. Drag the file into your applications folder
3. Test the installation: `kubectl version` You should see the version of the client and the server version as shown here:
![Display version of kubernetes and server version](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/what-you-should-see.png)

4. If you are running kubernetes using colima, you the server version (Kubernetes) may be missing, as shown here: 
![Showing image of server not found](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/verify-installation.png)

5. This is easy to fix. When I look at my "contexts", it shows I'm running colima. Shut it down, as show below. Rerun the get-contexts and you should now see the option of rancher-desktop. 
```shell
kubectl config get-contexts
colima stop
kubectl config get-contexts
```
![showing get-context and colima stop in the CLI](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/stop-colima.png)

6. The `*` indicates which is your active version of Kubernetes. If it is not rancher-desktop, we need to change that with the following command
```shell
kubectl config use-context rancher-desktop
```
Our installation will now point to the rancher desktop. And when we run `kubectl version` it will correctly demostrate a Client and a Server Version.
![showing use-context in the CLI](https://github.com/twlabs/ROTC-semi-guided-material/blob/rancher-for-rotc/images/use-context.png)

Now you can begin using Kubernetes from your CLI.
