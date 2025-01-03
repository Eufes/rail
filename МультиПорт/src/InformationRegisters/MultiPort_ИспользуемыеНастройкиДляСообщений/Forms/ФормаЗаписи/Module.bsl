
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ИзФормыСЗаданнымТипом") 
		И Параметры.ЗначенияЗаполнения.Свойство("ТипСообщения", Запись.ТипСообщения)
		И ЗначениеЗаполнено(Запись.ТипСообщения)
		Тогда
		Элементы.ТипСообщения.Доступность = Ложь;		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Запись.ТипСообщения) Тогда
		УстановитьОграничениеПоВыборуТипа();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСообщенияПриИзменении(Элемент)
	
	УстановитьОграничениеПоВыборуТипа();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОграничениеПоВыборуТипа()
	
	МассивТипов = Новый Массив;
	Если ТипЗнч(Запись.ТипСообщения) = Тип("СправочникСсылка.MultiPort_ТипИсходящегоСообщения") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.MultiPort_НастройкиИсходящихСообщений"));
	ИначеЕсли ТипЗнч(Запись.ТипСообщения) = Тип("СправочникСсылка.MultiPort_ТипВходящегоСообщения") Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.MultiPort_НастройкиВходящихСообщений"));
	Иначе
		МассивТипов.Добавить(Тип("Неопределено"));		
	КонецЕсли;
	ДопустимыйТип = Новый ОписаниеТипов(МассивТипов);
	
	Элементы.НастройкаДляСообщения.ОграничениеТипа = ДопустимыйТип;	
	Элементы.НастройкаДляСообщения.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти

