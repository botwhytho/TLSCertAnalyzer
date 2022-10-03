Class {
	#name : #TLSCertificate,
	#superclass : #Object,
	#instVars : [
		'issuer',
		'subject',
		'text',
		'rawCert'
	],
	#category : #TLSCertAnalyzer
}

{ #category : #accessing }
TLSCertificate >> expiresOn [
	^ ((self text lines
		in: [ :lines | 
			lines
				at: (lines detectIndex: [ :line | line includesSubstring: 'Validity' ]) + 2 ])
		copyReplaceAll: 'Not After :'
		with: '') trimBoth
]

{ #category : #accessing }
TLSCertificate >> gtCertDetailsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Cert Details';
		priority: 0;
		stencil: [ BrVerticalPane new
				matchParent;
				addChildren: {BlTextElement new
							text: self subject asRopedText;
							padding: (BlInsets all: 10);
							border: (BlBorder paint: (Color gray alpha: 0.2) width: 1).
						BlTextElement new
							text: self issuer asRopedText;
							padding: (BlInsets all: 10);
							border: (BlBorder paint: (Color gray alpha: 0.2) width: 1).
						BrHorizontalPane new
							matchParent;
							addChildren: {BrEditor new
										text: self rawCert;
										padding: (BlInsets all: 10);
										border: (BlBorder paint: (Color gray alpha: 0.2) width: 1);
										hMatchParent;
										vMatchParent;
										aptitude: (BrGlamorousRegularEditorAptitude new
												glamorousRegularFont;
												glamorousRegularSmallSize).
									BrEditor new
										text: self text;
										padding: (BlInsets all: 10);
										border: (BlBorder paint: (Color gray alpha: 0.2) width: 1);
										hMatchParent;
										vMatchParent;
										aptitude: (BrGlamorousRegularEditorAptitude new
												glamorousRegularFont;
												glamorousRegularSmallSize)}} ]
]

{ #category : #accessing }
TLSCertificate >> issuer [

	^ issuer
]

{ #category : #accessing }
TLSCertificate >> issuer: anObject [

	issuer := anObject
]

{ #category : #accessing }
TLSCertificate >> printOn: aStream [
	aStream
		nextPutAll: ('=' split: (self subject copyReplaceAll: 'subject=' with: '')) last
]

{ #category : #accessing }
TLSCertificate >> rawCert [

	^ rawCert
]

{ #category : #accessing }
TLSCertificate >> rawCert: anObject [

	rawCert := anObject
]

{ #category : #accessing }
TLSCertificate >> subject [

	^ subject
]

{ #category : #accessing }
TLSCertificate >> subject: anObject [

	subject := anObject
]

{ #category : #accessing }
TLSCertificate >> text [

	^ text
]

{ #category : #accessing }
TLSCertificate >> text: anObject [

	text := anObject
]

{ #category : #accessing }
TLSCertificate >> validFrom [
	^ ((self text lines
		in: [ :lines | 
			lines
				at: (lines detectIndex: [ :line | line includesSubstring: 'Validity' ]) + 1 ])
		copyReplaceAll: 'Not Before:'
		with: '') trimBoth
]
