Class {
	#name : #TLSCertAnalyzer,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'certs'
	],
	#category : #TLSCertAnalyzer
}

{ #category : #accessing }
TLSCertAnalyzer class >> gtCertsFor: aView [
	<gtClassView>
	^ aView forward
		title: 'Certs';
		priority: 1;
		object: self uniqueInstance;
		view: #gtCertsFor:
]

{ #category : #accessing }
TLSCertAnalyzer >> certs [
	^ certs ifNil: [ certs := OrderedCollection new ]
]

{ #category : #accessing }
TLSCertAnalyzer >> certs: anObject [

	certs := anObject
]

{ #category : #accessing }
TLSCertAnalyzer >> exploreNewCert [
	^ BrHorizontalPane new
		hMatchParent;
		vFitContent;
		padding: (BlInsets all: 10);
		in: [ :aPane | 
			| fileOrUrl proxy |
			fileOrUrl := BrEditor new.
			aPane
				addChildren: {self fileSelectorDropdown: fileOrUrl.
						BrLabel new
							text: 'Or enter Url:';
							aptitude: BrGlamorousLabelAptitude.
						fileOrUrl
							text: '';
							padding: (BlInsets all: 3);
							border: (BlBorder paint: (Color gray alpha: 0.2) width: 1);
							hMatchParent;
							vFitContent;
							aptitude: (BrGlamorousRegularEditorAptitude new
									glamorousRegularFont;
									glamorousRegularSmallSize).
						BrLabel new
							text: 'Proxy (Optional)';
							aptitude: BrGlamorousLabelAptitude.
						proxy := BrEditor new
								text: '';
								padding: (BlInsets all: 3);
								border: (BlBorder paint: (Color gray alpha: 0.2) width: 1);
								hMatchParent;
								vFitContent;
								aptitude: (BrGlamorousRegularEditorAptitude new
										glamorousRegularFont;
										glamorousRegularSmallSize).
						BrButton new
							aptitude: BrGlamorousButtonWithLabelAptitude new;
							label: 'Explore';
							action: [ :aButtonElement | 
								| viewContent |
								aButtonElement phlow
									spawnObject: (fileOrUrl text asString
											in: [ :aFileOrUrl | 
												(TLSCertificateChain
													load: (aFileOrUrl asFileReference ifExists: #yourself ifAbsent: [ aFileOrUrl asZnUrl ]))
													in: [ :aCertChain | 
														aCertChain source isFile
															ifFalse: [ proxy text asString ifNotEmpty: [ :notEmpty | aCertChain proxy: notEmpty ] ].
														self certs add: aCertChain.
														aCertChain ] ]).
								viewContent := aButtonElement
										allParentsDetect: [ :each | each phlow isViewContent ]
										ifFound: [ :found | found ]
										ifNone: [ nil ].
								viewContent phlow syncUpdate ]} ]
]

{ #category : #accessing }
TLSCertAnalyzer >> fileSelectorDropdown: anEditor [
	| aDropdownLook buttonElement |
	buttonElement := BrButton new
			aptitude: BrGlamorousButtonWithLabelAptitude;
			label: 'Choose Local Certificate File'.

	aDropdownLook := BrGlamorousWithDropdownAptitude
			handle: [ BrButton new
					aptitude: BrGlamorousButtonWithLabelAptitude;
					label: 'Choose Local Certificate File' ]
			content: [ BrFileSelector new
					folder: FileLocator home;
					okAction: [ :aFileOrDirectory :aButton | 
						aFileOrDirectory
							ifFile: [ anEditor text: aFileOrDirectory pathString.
								aButton fireEvent: BrDropdownHideWish new ]
							ifDirectory: [ self inform: 'Please choose a file and not a directory.'.
								aButton fireEvent: BrDropdownHideWish new ]
							ifAbsent: [  ].
						anEditor text: aFileOrDirectory pathString.
						aButton fireEvent: BrDropdownHideWish new ];
					buttonLabel: 'Select Certificate File';
					hFitContent;
					padding: (BlInsets all: 20) ].

	^ buttonElement addAptitude: aDropdownLook
]

{ #category : #accessing }
TLSCertAnalyzer >> gtCertsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Certs';
		priority: 1;
		stencil: [ BrVerticalPane new
				matchParent;
				addChildren: {self exploreNewCert.
						((self certs sorted: #asString ascending) gtItemsFor: GtPhlowView empty)
							asElement} ]
]
