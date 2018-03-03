﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.ДокументыПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Заполнение нового документа.
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц, ДатаСобытия",
			"Объект.Организация",
			"Объект.Ответственный",
			"Объект.ПериодРегистрации",
			"Объект.ДатаСобытия");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если НЕ ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
			Объект.ПериодРегистрации  = ТекущаяДатаСеанса();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.ВидПособия) Тогда
			Если НЕ ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации) Тогда
				Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности;
				Объект.ПособиеНаПогребениеСотруднику = Ложь;
			Иначе
				Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью;
				Объект.ПособиеНаПогребениеСотруднику = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
		
		Если ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
			РассчитатьПособие();
		КонецЕсли;  
		
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйФормы.УстановитьДоступныеХарактерыВыплаты(Элементы);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки".
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПереключательВидПособия();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение И ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ПослеЗаписиДокументЕдиновременноеПособиеЗаСчетФСС", Объект.ИсправленныйДокумент, ЭтаФорма);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ИсправленныйДокумент) Тогда
		Оповестить("ИсправленДокумент", , Объект.ИсправленныйДокумент);
	КонецЕсли;
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ДанныеВРеквизит();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПослеЗаписиДокументЕдиновременноеПособиеЗаСчетФСС" И Параметр = Объект.Ссылка Тогда
		ТолькоПросмотр = Истина;
	ИначеЕсли ИмяСобытия = "ИсправленДокумент" И Источник = Объект.Ссылка Тогда
		ДанныеВРеквизит();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПособияПриИзменении(Элемент)
	
	Если ВидПособия = 0 Тогда
		Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности");
		Объект.ПособиеНаПогребениеСотруднику = Ложь;
	ИначеЕсли ВидПособия = 1 Тогда
		Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка");
		Объект.ПособиеНаПогребениеСотруднику = Ложь;
	ИначеЕсли ВидПособия = 2 Тогда
		Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью");
		Объект.ПособиеНаПогребениеСотруднику = Ложь;
	ИначеЕсли ВидПособия = 3 Тогда
		Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью");
		Объект.ПособиеНаПогребениеСотруднику = Истина;
	КонецЕсли;
	
	УстановитьВыплату(ЭтаФорма);
	
	ВидПособияПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВыплату(Форма)
	Если Форма.ВидПособия = 2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВыплатаГруппа", "Видимость", Ложь);
		Форма.Объект.ПорядокВыплаты = ПредопределенноеЗначение("Перечисление.ХарактерВыплатыЗарплаты.Зарплата");
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.КоманднаяПанель.ПодчиненныеЭлементы, "ФормаОбработкаСозданиеВедомостейНаВыплатуЗарплатыСоздатьВедомостиПоРасчетномуДокументу", "Видимость", Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ВыплатаГруппа", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.КоманднаяПанель.ПодчиненныеЭлементы, "ФормаОбработкаСозданиеВедомостейНаВыплатуЗарплатыСоздатьВедомостиПоРасчетномуДокументу", "Видимость", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	ФизическоеЛицоПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.ВидПособия.Пустая() Тогда
		ПоказатьПредупреждение(, Нстр("ru='Сначала укажите вид пособия.'"));
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт

	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	УстановитьСписокВыбораВидаПособия();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	УстановитьСписокВыбораВидаПособия();
КонецПроцедуры

&НаКлиенте
Процедура ДатаСобытияПриИзменении(Элемент)
	ДатаСобытияПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПорядокВыплатыПриИзменении(Элемент)
	
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ЕдиновременноеПособиеЗаСчетФСС");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ЕдиновременноеПособиеЗаСчетФСС");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ЕдиновременноеПособиеЗаСчетФСС");
КонецПроцедуры
// Конец ИсправлениеДокументов

&НаКлиенте
Процедура Рассчитать(Команда)
	  РассчитатьПособие(Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	РасчетЗарплатыРасширенныйФормы.ПорядокВыплатыЗарплатыДополнитьФорму(ЭтаФорма);
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
	ДанныеВРеквизит();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизит()
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
	УстановитьСписокВыбораВидаПособия();
	
	Если Не ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма);
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадры.УстановитьПоляИсправления(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСписокВыбораВидаПособия()
	Элементы.ВидПособия.СписокВыбора.ЗагрузитьЗначения(СписокВыбораВидаПособия().ВыгрузитьЗначения());
	УстановитьПредставленияЭлементовСписка(Элементы.ВидПособия.СписокВыбора);
КонецПроцедуры

&НаСервере
Процедура РассчитатьПособие(ВыводитьСообщения = Ложь)
	  
	Если НЕ ДокументЗаполненПравильно(ВыводитьСообщения) Тогда
		Объект.Начислено = 0;
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидПособия  = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью Тогда
	  ГосударственноеПособиеВТвердыхСуммах = "ВСвязиСоСмертью";
	ИначеЕсли Объект.ВидПособия  = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности Тогда	
	  ГосударственноеПособиеВТвердыхСуммах = "ПриПостановкеНаУчетВРанниеСрокиБеременности";
	ИначеЕсли Объект.ВидПособия  = Перечисления.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка Тогда	
		ГосударственноеПособиеВТвердыхСуммах = "ПриРожденииРебенка";
	КонецЕсли;
	
	РайонныйКоэффициентРФнаНачалоСобытия = 1;
	
	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация = Объект.Организация;
	ПараметрыПолученияСотрудниковОрганизаций.СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.ФизическоеЛицо);
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода = Объект.ДатаСобытия;	
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода = Объект.ДатаСобытия;
	ПараметрыПолученияСотрудниковОрганизаций.КадровыеДанные = "Подразделение, ВидЗанятости";
		
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудниковОрганизаций);
	
	Запрос.Текст = 
	"ВЫБРАТЬ * ИЗ ВТСотрудникиОрганизации";
	
	КадровыеДанные = Запрос.Выполнить().Выгрузить();
	
	КадровыеДанныеОсновноеМестоРаботы = КадровыеДанные.НайтиСтроки(Новый Структура("ВидЗанятости", Перечисления.ВидыЗанятости.ОсновноеМестоРаботы)); 
	
	Если НЕ КадровыеДанныеОсновноеМестоРаботы.Количество() = 0 Тогда
		РайонныйКоэффициентРФнаНачалоСобытия = РасчетЗарплатыРасширенный.РайонныйКоэффициентРФ(КадровыеДанныеОсновноеМестоРаботы[0].Подразделение);
	Иначе
		РайонныйКоэффициентРФнаНачалоСобытия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "РайонныйКоэффициентРФ");
	КонецЕсли;
	
	Если Объект.ВидПособия <> Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью 
		И ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации) Тогда
		Объект.Начислено = 0;	
	Иначе
		Объект.Начислено = УчетПособийСоциальногоСтрахованияРасширенный.РазмерГосударственногоПособия(ГосударственноеПособиеВТвердыхСуммах, Объект.ДатаСобытия) * РайонныйКоэффициентРФнаНачалоСобытия; 	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДокументЗаполненПравильно(ВыводитьСообщения = Истина)
	ТекстСообщения = "";
	СтруктураСообщений  = Новый Соответствие;
	ДокументЗаполненПравильно = Истина;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаСобытия) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана дата выплаты пособия.'");
		СтруктураСообщений.Вставить("ДатаСобытия", ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидПособия) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан вид выплачиваемого пособия.'");
		СтруктураСообщений.Вставить("ВидПособия", ТекстСообщения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизическоеЛицо) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан получатель пособия.'");
		СтруктураСообщений.Вставить("ФизическоеЛицо", ТекстСообщения);
	КонецЕсли;
	
	ДокументЗаполненПравильно = СтруктураСообщений.Количество() = 0;
	
	Если ВыводитьСообщения И НЕ ДокументЗаполненПравильно Тогда
		Для каждого Сообщение Из СтруктураСообщений Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение.Значение,,"Объект" + ?(Сообщение.Ключ = "","",".") + Сообщение.Ключ);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ДокументЗаполненПравильно;	
КонецФункции // ()

&НаСервере
Функция ОбновитьПараметрыВыбораФизическогоЛица()
	
	НовыйМассив = Новый Массив();
	
	Если НЕ (Объект.ВидПособия = Перечисления.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью
		И НЕ Объект.ПособиеНаПогребениеСотруднику) Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Организация", Объект.Организация);
		НовыйМассив.Добавить(НовыйПараметр);
		
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ВидЗанятости", ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ОсновноеМестоРаботы"));
		НовыйМассив.Добавить(НовыйПараметр);

	Иначе
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Организация", Неопределено);
		НовыйМассив.Добавить(НовыйПараметр);
	КонецЕсли;	
	
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ФизическоеЛицо.ПараметрыВыбора = НовыеПараметры;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "ФизическоеЛицо");
	КонецЕсли; 
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.ФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	
	ОбновитьПараметрыВыбораФизическогоЛица();
	
	УстановитьСписокВыбораВидаПособия();
	
	РасчетЗарплатыРасширенныйФормы.ОбновитьПлановыеДатыВыплатыПоОрганизации(ЭтаФорма);
	РасчетЗарплатыРасширенныйКлиентСервер.УстановитьПланируемуюДатуВыплаты(ЭтаФорма, ОписаниеДокумента());
	
КонецПроцедуры

&НаСервере
Процедура ВидПособияПриИзмененииНаСервере()
	ОбновитьПараметрыВыбораФизическогоЛица();
	РассчитатьПособие();
КонецПроцедуры

&НаСервере
Процедура ДатаСобытияПриИзмененииНаСервере()
	РассчитатьПособие();
КонецПроцедуры

&НаСервере
Функция СписокВыбораВидаПособия()
	
	СписокВыбора = Новый СписокЗначений;

	Если НЕ ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(Объект.Организация, Объект.ПериодРегистрации)  Тогда
		СписокВыбора.Добавить(0);
		СписокВыбора.Добавить(1);
	КонецЕсли;	
	СписокВыбора.Добавить(2);
	СписокВыбора.Добавить(3);
	Возврат СписокВыбора;
	
КонецФункции

&НаСервере
Процедура ФизическоеЛицоПриИзмененииНаСервере()
	РассчитатьПособие();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПереключательВидПособия()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ПриПостановкеНаУчетВРанниеСрокиБеременности") Тогда
			ВидПособия = 0;
		ИначеЕсли Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ПриРожденииРебенка") Тогда
			ВидПособия = 1;
		ИначеЕсли Объект.ВидПособия = ПредопределенноеЗначение("Перечисление.ПереченьПособийСоциальногоСтрахования.ВСвязиСоСмертью") Тогда
			ВидПособия = ?(Объект.ПособиеНаПогребениеСотруднику, 3, 2);
		КонецЕсли;
		
	КонецЕсли;
	УстановитьВыплату(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставленияЭлементовСписка(СписокВыбора)
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		
		Если ЭлементСписка.Значение = 0 Тогда
			ЭлементСписка.Представление = "При постановке на учет в ранние сроки беременности";
		ИначеЕсли ЭлементСписка.Значение = 1 Тогда
			ЭлементСписка.Представление = "При рождении ребенка";
		ИначеЕсли ЭлементСписка.Значение = 2 Тогда
			ЭлементСписка.Представление = "Социальное пособие на погребение, выплачиваемое стороннему лицу";
		ИначеЕсли ЭлементСписка.Значение = 3 Тогда
			ЭлементСписка.Представление = "Социальное пособие на погребение, выплачиваемое сотруднику";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента()
	
	Возврат Новый Структура("МесяцНачисленияИмя,ПорядокВыплатыИмя,ПланируемаяДатаВыплатыИмя", "ПериодРегистрации", "ПорядокВыплаты", "ПланируемаяДатаВыплаты");
	
КонецФункции

#КонецОбласти
