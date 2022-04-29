import matplotlib.pyplot as plt

def get_error(filename,metric):
    with open(filename, encoding='utf-8') as fp:
        count=0

        for line in fp:
            count+=1
            if (count>8):
                labeldata = line.strip().split(': ')
                if(labeldata[0]==metric):

                    err=float(labeldata[1])


    return err

def compute_results(PSF,crop,file_list,metric):
    #crop ="crop_before" or "crop_after"
    if (PSF==True):
        basename='./results_v2/PSF/'+crop
    else:
        basename='./results_v2/no_PSF/'+crop


    ERR=[]
    print(basename)
    for i in range(len(file_list)):
        err= get_error(basename + "/evaluation_" + file_list[i] + '.txt',metric)
        ERR.append(err)

    return ERR
def plot_metrics(file_list,metric):
    err= compute_results(PSF=False, crop="crop_after", file_list=file_list,metric=metric)
    err1 = compute_results(PSF=False, crop="crop_before", file_list=file_list, metric=metric)
    err2 = compute_results(PSF=True, crop="crop_after", file_list=file_list, metric=metric)
    err3 = compute_results(PSF=True, crop="crop_before", file_list=file_list, metric=metric)
    #fig, axs = plt.subplots(1)


    plt.plot(file_list,err,label='crop_after')

    plt.plot(file_list, err1,label="crop_before")
    plt.plot(file_list, err2, label="crop_before_PSF")
    plt.plot(file_list, err3, label="crop_before_PSF")
    plt.title(metric + ' obtained W/O PSF ')
    plt.xlabel('method')
    plt.ylabel(metric)
    plt.legend()
    save_path = './curves/' + metric + '.png'
    plt.savefig(save_path)

    plt.show()
    print(metric)
    print(err)
    print(err1)
    print(err2)
    print(err3)



if __name__ == "__main__":
    file_list = ['R0_', 'R20_', "full_", "double_estimate_", "patch_"]
    plot_metrics(file_list,"THRESH 1.25")
