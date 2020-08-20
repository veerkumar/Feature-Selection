function plotFeat(FeatStat)

        FeatIndex=FeatStat(:,1);   
        FeatScore=FeatStat(:,2);      
        
        % Get the list of missing indexes
        % FeatIndex		list of variables selected
        % notSel        list of indexes not present
        % nv            total number of variables
        nv=15500;
        notSel=[];
        for cnti=1:nv,
            selected=0;
            for cntj=1:length(FeatIndex)
              if FeatIndex(cntj)==cnti
                selected=1;
                break;
              end
            end
            if ~(selected)
              notSel=[notSel, cnti];
            end
        end
       
        % Append the missing indexes to the Feat index
        FeatStat=[FeatIndex' notSel; FeatScore' zeros(size(notSel))]';
        FeatStat=sortrows(FeatStat,1);
        FeatScore=FeatStat(:,2)'; 
        FeatStat=[];
%        Face=dlmread('data\Face.txt');
        Face=dlmread('data/Face.txt'); %on MAC
        % reshape data to display
        size(FeatScore);
        FeatListOD=FeatScore(1:7750);
        FeatListOD=reshape(FeatListOD,[125 62]);
        FeatListOD=[FeatListOD fliplr(FeatListOD)];
        mnOD=min(FeatListOD(:));
        mxOD=max(FeatListOD(:));        
        FeatListOD(FeatListOD<=0)=0;
        FeatListOD(1)=mnOD; FeatListOD(2)=mxOD;
                    
        FeatListHD=FeatScore(7751:end);
        FeatListHD=reshape(FeatListHD,[125 62]);
        FeatListHD=[FeatListHD fliplr(FeatListHD)];
        mnHD=min(FeatListHD(:));
        mxHD=max(FeatListHD(:));        
        FeatListHD(FeatListHD<=0)=0;
        FeatListHD(1)=mnHD; FeatListHD(2)=mxHD;
        FeatScore=[];


        figure;
        subplot(121);
            surf(flipud(Face+FeatListOD),flipud(FeatListOD),'facecolor','interp','edgecolor','interp','edgecolor','none')
            colorbar vert
            colormap jet;
            view(0,90)
            freezeColors;
            freezeColors(colorbar);
            hold on;
            imMask=imread('data/mask.jpg');
            surface(flipud(Face),(imMask),'FaceColor','texturemap',...
                    'EdgeColor','none',...
                    'CDataMapping','direct');
            colormap gray
            view(0,90);
            axis tight;
            imshow(imMask)
            view(0,90);
            hold off;
            title('OD features');
        subplot(122);
            surf(flipud(Face+FeatListHD),flipud(FeatListHD),'facecolor','interp','edgecolor','interp','edgecolor','none')
            colorbar vert
            colormap jet;
            view(0,90)
            freezeColors;
            freezeColors(colorbar);
            hold on;
            imMask=imread('data/mask.jpg');
            surface(flipud(Face),(imMask),'FaceColor','texturemap',...
                    'EdgeColor','none',...
                    'CDataMapping','direct');
            colormap gray
            view(0,90);
            axis tight;
            imshow(imMask)
            view(0,90);
            hold off;
            title('HD features');
            xlabel('You can also rotate these figures in 3D');
units=get(gcf,'units');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'units',units);






