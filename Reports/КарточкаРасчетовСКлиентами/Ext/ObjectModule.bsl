﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ПараметрыОтчет")
			И Параметры.ПараметрыОтчет.Свойство("ДополнительныеПараметры") Тогда 
		
		Если Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "КарточкаРасчетовСКлиентом" Тогда
			
			Параметры.КлючВарианта = СформироватьПараметрыКарточкаРасчетовСКлиентом(Параметры.ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры);
			
		ИначеЕсли Параметры.ПараметрыОтчет.ДополнительныеПараметры.ИмяКоманды = "КарточкаРасчетовСКлиентомПоДокументам" Тогда
			
			СтруктураНастроек = НастройкиОтчета(Параметры.ПараметрКоманды);
			ЗначенияФункциональныхОпций = СтруктураНастроек.ЗначенияФункциональныхОпций;
			СтрокаБазовая = ?(ЗначенияФункциональныхОпций.БазоваяВерсия, "Базовая", "");
			
			Параметры.КлючВарианта = "КарточкаРасчетовСКлиентамиПоДокументамКонтекст" + СтрокаБазовая;
			
			Параметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = Параметры.ПараметрКоманды;
			
			ЭтаФорма.ФормаПараметры.Отбор = СтруктураНастроек.СтруктураОтборов;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	ВзаиморасчетыСервер.ЗаменитьДокументыРасчетовСКлиентами(ФормаПараметры);
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеПользовательскихНастроекНаСервере
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	НастроитьПользовательскиеНастройкиПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеПользовательскиеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьПользовательскиеНастройкиПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОтгрузкуБезПереходаПраваСобственности") Тогда
		КомпоновкаДанныхСервер.ОтключитьВыбранноеПолеВПользовательскихНастройках(КомпоновщикНастроекФормы,
			"ДолгКлиентаВсегоНачальныйОстаток");
		КомпоновкаДанныхСервер.ОтключитьВыбранноеПолеВПользовательскихНастройках(КомпоновщикНастроекФормы,
			"ДолгКлиентаВсегоКонечныйОстаток");
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПараметрыКарточкаРасчетовСКлиентом(ПараметрКоманды, ПараметрыФормы, Параметры)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		ЭтоМассив = Истина;
		Если ПараметрКоманды.Количество() > 0 Тогда
			ПервыйЭлемент = ПараметрКоманды[0];
		Иначе
			ПервыйЭлемент = Неопределено;
		КонецЕсли;
	Иначе
		ЭтоМассив = Ложь;
		ПервыйЭлемент = ПараметрКоманды;
	КонецЕсли;
	
	Если ЭтоМассив Тогда
		ЕстьПодчиненныеПартнеры = Ложь;
		Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
			Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
				ЕстьПодчиненныеПартнеры = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
	КонецЕсли;
	
	СтрокаБазовая = ?(ПолучитьФункциональнуюОпцию("БазоваяВерсия"), "Базовая", "");
	
	КлючВарианта = Неопределено;
	
	Если ЕстьПодчиненныеПартнеры Тогда
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		Если ЭтоМассив Тогда
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
		Иначе
			ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		КонецЕсли;
		ЭлементОтбора.ПравоеЗначение = ПараметрКоманды;
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
		ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
		Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
		
		КлючВарианта = "КарточкаРасчетовСКлиентамиКонтекст" + СтрокаБазовая;
	Иначе
		ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
		ПараметрыФормы.КлючНазначенияИспользования = ПараметрКоманды;
		Параметры.КлючНазначенияИспользования = ПараметрКоманды;
		
		Если ЭтоМассив И ПараметрКоманды.Количество() = 1 Тогда
			КлючВарианта = "КарточкаРасчетовСКлиентомКонтекст" + СтрокаБазовая;
		Иначе
			КлючВарианта = "КарточкаРасчетовСКлиентамиКонтекст" + СтрокаБазовая;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КлючВарианта;
	
КонецФункции

Функция НастройкиОтчета(ПараметрКоманды)
	
	ЗначенияФункциональныхОпций = Новый Структура("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента"));
	Типы.Добавить(Тип("ДокументСсылка.РеализацияУслугПрочихАктивов"));
	Типы.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
	Типы.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	Типы.Добавить(Тип("ДокументСсылка.ВыкупВозвратнойТарыКлиентом"));
	Типы.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	Типы.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	//++ НЕ УТКА
	Типы.Добавить(Тип("ДокументСсылка.ЗаказДавальца"));
	Типы.Добавить(Тип("ДокументСсылка.ОтчетДавальцу"));
	//-- НЕ УТКА
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ЗначенияФункциональныхОпций", ЗначенияФункциональныхОпций);
	СтруктураНастроек.Вставить("СтруктураОтборов",
	                           ВзаиморасчетыСервер.СтруктураОтборовОтчетовРасчетыСКлиентами(ПараметрКоманды,
	                                                                                        "КарточкаРасчетовСКлиентами",
	                                                                                        "КарточкаРасчетовСКлиентомПоДокументам", 
	                                                                                        Типы));
	Возврат СтруктураНастроек
	
КонецФункции

#КонецОбласти

#КонецЕсли