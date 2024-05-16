﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьЗначенияСвязанныхПолей(); 
	
КонецПроцедуры 

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СообщениеПриИзменении(Элемент)
	УстановитьЗначенияСвязанныхПолей();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции  

&НаСервере
Процедура УстановитьЗначенияСвязанныхПолей()
	
	Если ЗначениеЗаполнено(Запись.Сообщение) Тогда
		ИменаРеквизитов = "ТипСообщения";
		СтруктураРеквизитов = EUF_ПроводникШлюзБСПСервер.ЗначенияРеквизитовОбъекта(Запись.Сообщение, ИменаРеквизитов);
		ТипСообщения = СтруктураРеквизитов.ТипСообщения; 
	КонецЕсли;
		
КонецПроцедуры
   
#КонецОбласти
