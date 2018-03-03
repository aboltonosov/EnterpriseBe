﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ИспользоватьРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	//++ НЕ УТ
	Если ИспользоватьРеглУчет Тогда
		ДоступныеСчетаУчетаТМЦВЭксплуатации();
	КонецЕсли;
	//-- НЕ УТ
	
	Элементы.ГруппаОтражениеВРеглУчета.Видимость = ИспользоватьРеглУчет;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	//++ НЕ УТ
	ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациям();
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИнвентарныйУчетПриИзменении(Элемент)
	
	//++ НЕ УТ
	Если Не Объект.ИнвентарныйУчет
		И Объект.СпособПогашенияСтоимостиБУ=ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПоНаработке") Тогда
		Объект.СпособПогашенияСтоимостиБУ = ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПоСроку");
	КонецЕсли;
	УстановитьДоступностьЭлементовФормы();
	//-- НЕ УТ
	
	Возврат; // Для УТ обработчик пустой
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПогашенияСтоимостиБУПриИзменении(Элемент)
	
	//++ НЕ УТ
	УстановитьДоступностьЭлементовФормы();
	//-- НЕ УТ
	
	Возврат; // Для УТ обработчик пустой
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСчетаРеглУчетаПоОрганизациям(Команда)
	
	//++ НЕ УТ
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаВопросЗаписиОбъекта", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для продолжения необходимо записать объект. Записать?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Возврат;
	КонецЕсли;
	ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациям();
	//-- НЕ УТ
	
	Возврат; // Чтобы в УТ был не пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	//++ НЕ УТ
	ПоНаработке = (Объект.СпособПогашенияСтоимостиБУ=Перечисления.СпособыПогашенияСтоимостиТМЦ.ПоНаработке);
	
	Элементы.ОбъемНаработки.Доступность = ПоНаработке;
	Элементы.ЕдиницаИзмеренияНаработки.Доступность = ПоНаработке;
	
	Элементы.СрокЭксплуатации.АвтоОтметкаНезаполненного = Не ПоНаработке;
	Элементы.СрокЭксплуатации.ОтметкаНезаполненного = Не ПоНаработке;
	
	// 4D:ERP для Беларуси, АлексейЧ, 27.10.2017 14:49:13 
	// Варианты способов погашения стоимости (НАЛОГОВЫЙ УЧЕТ) "По сроку эксплуатации",
	// По наработке"., № 16213
	// {
	
	//Элементы.СпособПогашенияСтоимостиНУ.ТолькоПросмотр =
	//	(Объект.СпособПогашенияСтоимостиБУ=Перечисления.СпособыПогашенияСтоимостиТМЦ.ПриПередаче);
	Элементы.СпособПогашенияСтоимостиНУ.ТолькоПросмотр = Ложь;
	// }
	// 4D

	//-- НЕ УТ
	
	Возврат; // Для УТ обработчик пустой
	
КонецПроцедуры

//++ НЕ УТ

&НаКлиенте
Процедура ОбработкаВопросЗаписиОбъекта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
		ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациям();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациям()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КатегорияЭксплуатации", Объект.Ссылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНастройкиСчетовРеглУчетаПоОрганизациям", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.ПорядокОтраженияТМЦВЭксплуатации.Форма.ФормаНастройки", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеНастройкиСчетовРеглУчетаПоОрганизациям(Результат, ДополнительныеПараметры) Экспорт
	
	ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациям();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациям()
	
	ЗаголовокКоманды = НСтр("ru = 'Посмотреть настройки счетов учета по организациям'");
	
	Если ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ПорядокОтраженияТМЦВЭксплуатации) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Количество
		|ИЗ
		|	РегистрСведений.ПорядокОтраженияТМЦВЭксплуатации КАК ПорядокОтражения
		|ГДЕ
		|	ПорядокОтражения.КатегорияЭксплуатации = &КатегорияЭксплуатации";
		Запрос.УстановитьПараметр("КатегорияЭксплуатации", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ЗаголовокКоманды = НСтр("ru = 'Настроить счета учета по организациям'");
		Иначе
			ЗаголовокКоманды  = НСтр("ru = 'Изменить настройки счетов учета по организациям'");
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.НастроитьСчетаРеглУчетаПоОрганизациям.Заголовок = ЗаголовокКоманды; 
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаТМЦВЭксплуатации()
	
	Если Не ПравоДоступа("Просмотр",  Метаданные.ПланыСчетов.Хозрасчетный) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаТМЦВЭксплуатации();
	
	МассивПараметрыВыбора = Новый Массив;
	МассивПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаУчета)));
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметрыВыбора);
	
	МассивПараметрыВыбора = Новый Массив;
	МассивПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаЗабалансовогоУчета)));
	Элементы.СчетЗабалансовогоУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	ПриПередаче = (Объект.СпособПогашенияСтоимостиБУ=ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПриПередаче"));
	
	ПоНаработке = (Объект.СпособПогашенияСтоимостиБУ=ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПоНаработке"));
	
	Элементы.ОбъемНаработки.Доступность = ПоНаработке;
	Элементы.ЕдиницаИзмеренияНаработки.Доступность = ПоНаработке;
	
	Элементы.СрокЭксплуатации.АвтоОтметкаНезаполненного = Не ПоНаработке;
	Элементы.СрокЭксплуатации.ОтметкаНезаполненного = Не ПоНаработке;
	
	Если Объект.СпособПогашенияСтоимостиНУ <> ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПриПередаче") Тогда
		Объект.СпособПогашенияСтоимостиНУ = Объект.СпособПогашенияСтоимостиБУ;
	КонецЕсли;
	
	// 4D:ERP для Беларуси, АлексейЧ, 27.10.2017 14:49:13 
	// Варианты способов погашения стоимости (НАЛОГОВЫЙ УЧЕТ) "По сроку эксплуатации",
	// По наработке"., № 16213
	// {
	
	//Элементы.СпособПогашенияСтоимостиНУ.ТолькоПросмотр = ПриПередаче;
	Элементы.СпособПогашенияСтоимостиНУ.ТолькоПросмотр = Ложь;
	// }
	// 4D
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти