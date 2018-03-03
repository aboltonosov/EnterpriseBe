﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ПараметрыДетализации);
	
	Если Не ЗначениеЗаполнено(ПодразделениеПредприятия) Или Не ЗначениеЗаполнено(ВидОперации) Тогда
		Заголовок = НСтр("ru = 'Сотрудники организации'");
	ИначеЕсли ОблагаетсяЕНВД Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сотрудники организации (%1, %2, облагается ЕНВД)'"),
		СокрЛП(ПодразделениеПредприятия),
		СокрЛП(ВидОперации));
	Иначе
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сотрудники организации (%1, %2)'"),
		СокрЛП(ПодразделениеПредприятия),
		СокрЛП(ВидОперации));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресВХранилище) Тогда
		ДетализацияНачислений = ПолучитьИзВременногоХранилища(АдресВХранилище);
		НачисленнаяЗарплатаИВзносыПоФизлицам.Загрузить(ДетализацияНачислений.НачисленнаяЗарплатаИВзносыПоФизлицам);
	КонецЕсли;
	
	ЗаполнитьДополнительныеРеквизиты();
	
	// 4D:ERP для Беларуси, Яна, 04.09.2017 14:51:30 
	// Локализовать документ "Отражение зарплаты в финансовом учете", №15826 
	// {
	//УстановитьОтображениеВзносов();
	// }
	// 4D
			
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносыПоФизлицам Цикл
		
		ТекстСообщения = НСтр("ru = 'Не заполнено поле %1 в строке %2'");
		
		Если Не ЗначениеЗаполнено(Строка.ПодразделениеПредприятия) И ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru = 'Подразделение-получатель'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "ПодразделениеПредприятия"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ВидОперации) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru = 'Вид операции'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "ВидОперации"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.СпособОтраженияЗарплатыВБухучете)
			И СпособОтраженияТребуется(Строка.ВидОперации, Строка.ВзносыВсего) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru = 'Способ отражения'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "СпособОтраженияЗарплатыВБухучете"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ФизическоеЛицо) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, НСтр("ru = 'Сотрудник'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "ФизическоеЛицо"),,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.Сумма) И Не ЗначениеЗаполнено(Строка.ВзносыВсего) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не заполнена сумма начисления и взносов в строке %1'"), Строка.Номер),
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносыПоФизлицам", Строка.Номер, "Сумма"),,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
			
		Если ЗавершениеРаботы Тогда
			
			ТекстПредупреждения = НСтр("ru='Данные были изменены.
					|Перед завершением работы рекомендуется сохранить изменения,
					|иначе измененные данные будут утеряны.'");
			
			Возврат;
			
		Иначе
			
			Отказ                = Истина;
			СтандартнаяОбработка = Ложь;
			
			ТекстВопроса       = Нстр("ru = 'Данные были изменены. Сохранить изменения?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисленнаяЗарплатаИВзносы

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПоФизлицамПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
		
		Если Не Копирование Тогда
			ЗаполнитьЗначенияСвойств(ТекущиеДанные, ЭтаФорма);
			ТекущиеДанные.ВидНачисленияОплатыТрудаДляНУ = ПредопределенноеЗначение("Перечисление.ВидыНачисленийОплатыТрудаДляНУ.пп1ст255");
			ТекущиеДанные.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.НачисленоДоход");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПриИзменении(Элемент)
	
	ЗаполнитьДополнительныеРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыВидОперацииПриИзменении(Элемент)
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
		
		// 4D:ERP для Беларуси, АлексейЧ, 18.12.2017 12:36:06 
		// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
		// {
		  Если ТекущиеДанные.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСЗН") Тогда	
		
			 ТекущиеДанные.ВзносыВсего 	= 0;
			 ТекущиеДанные.Белгосстрах 	= 0;
			 ТекущиеДанные.ФСЗН			= 0;
			 УстановитьУсловноеОформлениеБелгосстрахФСЗН();
			 
		 КонецЕсли;	 
		 // }
		 // 4D
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРСтраховаяПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРНакопительнаяПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРДоПредельнойВеличиныПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРСПревышенияПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРПоСуммарномуТарифуПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРНаДоплатуЛетчикамПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРНаДоплатуШахтерамПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыФССПриИзменении(Элемент)
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыФФОМСПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыТФОМСПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыФССНесчастныеСлучаиПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахБезСпецОценкиПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахСпецОценкаПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахБезСпецОценкиПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахСпецОценкаПриИзменении(Элемент)
	РассчитатьВзносыВсего();
КонецПроцедуры

// 4D:ERP для Беларуси, Яна, 04.09.2017 14:11:53 
// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
// {
&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыФСЗНПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПенсионныйФондПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыБелгосстрахПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыПСПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленнаяЗарплатаИВзносыССПриИзменении(Элемент)
	
	РассчитатьВзносыВсего();
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	Если Не СпособОтраженияТребуется(ТекущиеДанные.ВидОперации, ТекущиеДанные.ВзносыВсего) Тогда
		ТекущиеДанные.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

// }
// 4D

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьВзносыПодробно(Команда)
	
	ПоказатьВзносыПодробно = Не ПоказатьВзносыПодробно;
	Элементы.ПоказатьВзносыПодробно.Пометка = ПоказатьВзносыПодробно;
	УстановитьОтображениеВзносов();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность Тогда
		
		ЗавершитьРедактирование();
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделение(Команда)
	
	ВыделенныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ВыделенныеСтроки;
	
	Если НачисленнаяЗарплатаИВзносыПоФизлицам.Количество() = 0 Или Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для выполнения команды требуется выделить строки табличной части.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;

	
	ОткрытьФорму(
		"Справочник.СтруктураПредприятия.Форма.ФормаВыбора", 
		,
		ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьПодразделениеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодразделениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	ВыбранноеЗначение = Результат;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Для Каждого Строка Из ВыделенныеСтроки Цикл
			
			СтрокаТаблицы = НачисленнаяЗарплатаИВзносыПоФизлицам.НайтиПоИдентификатору(Строка);
			Если СтрокаТаблицы <> Неопределено Тогда
				СтрокаТаблицы.ПодразделениеПредприятия = ВыбранноеЗначение;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидОперации(Команда)
	
	ВыделенныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ВыделенныеСтроки;
	
	Если НачисленнаяЗарплатаИВзносыПоФизлицам.Количество() = 0 Или Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для выполнения команды требуется выделить строки табличной части.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;

	
	ОткрытьФорму(
		"Перечисление.ВидыОперацийПоЗарплате.Форма.ФормаВыбора",
		Новый Структура("ГруппаОпераций", "Начисления"),
		,,,
		ЭтаФорма, Новый ОписаниеОповещения("ЗаполнитьВидОперацииЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидОперацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	ВыбранноеЗначение = Результат;
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Для Каждого Строка Из ВыделенныеСтроки Цикл
			
			СтрокаТаблицы = НачисленнаяЗарплатаИВзносыПоФизлицам.НайтиПоИдентификатору(Строка);
			Если СтрокаТаблицы <> Неопределено Тогда
				
				СтрокаТаблицы.ВидОперации = ВыбранноеЗначение;
				
				Если Не СпособОтраженияТребуется(СтрокаТаблицы.ВидОперации, СтрокаТаблицы.ВзносыВсего) Тогда
					СтрокаТаблицы.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпособОтражения(Команда)
	
	ВыделенныеСтроки = Элементы.НачисленнаяЗарплатаИВзносы.ВыделенныеСтроки;
	
	Если НачисленнаяЗарплатаИВзносыПоФизлицам.Количество() = 0 Или Не ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для выполнения команды требуется выделить строки табличной части.'"));
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;
	
	ОткрытьФорму(
		"Справочник.СпособыОтраженияЗарплатыВБухУчете.Форма.ФормаВыбора", 
		,
		ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьСпособОтраженияЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпособОтраженияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	Для Каждого Строка Из ВыделенныеСтроки Цикл
		
		ДанныеСтроки = НачисленнаяЗарплатаИВзносыПоФизлицам.НайтиПоИдентификатору(Строка);
		
		Если СпособОтраженияТребуется(ДанныеСтроки.ВидОперации, ДанныеСтроки.ВзносыВсего) Тогда
			ДанныеСтроки.СпособОтраженияЗарплатыВБухучете = Результат
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ОтражениеЗарплатыВФинансовомУчетеУП.УсловноеОформлениеОперацийПоЗарплате(
		УсловноеОформление, "НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации", Элементы.НачисленнаяЗарплатаИВзносыВидОперации);
	
	// способ отражения не требуется для сдельной зарплаты и некоторых резервов
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыСпособОтражения.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыОблагаетсяЕНВД.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоСдельноДоход);
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы);
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	// способ отражения не требуется для расходов по страхованию за счет фонда
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыСпособОтражения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокЗначений = Новый СписокЗначений;
	
	// 4D:ERP для Беларуси, АлексейЧ, 18.12.2017 12:23:16 
	// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
	// {
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСЗН);
	// }
	// 4D
	
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС);
	
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	
	// 4D:ERP для Беларуси, АлексейЧ, 18.12.2017 12:23:16 
	// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
	// {
	УстановитьУсловноеОформлениеБелгосстрахФСЗН();	
	// }
	// 4D
	
	// если ЕНВД не применяется, то колонка не отображается
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыОблагаетсяЕНВД.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПрименяетсяЕНВД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры


// 4D:ERP для Беларуси, АлексейЧ, 18.12.2017 13:01:00 
// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
// {
&НаСервере
Процедура УстановитьУсловноеОформлениеБелгосстрахФСЗН()
	
	ОтражениеЗарплатыВФинансовомУчетеУП.УсловноеОформлениеОперацийПоЗарплате(
		УсловноеОформление, "НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации", Элементы.НачисленнаяЗарплатаИВзносыВидОперации);
	
	// суммы Белгосстрах и ФСЗН не должны отражаться при начислении за счет фонда ФСЗН
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыФСЗН.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокЗначений = Новый СписокЗначений;
	
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСЗН);
		
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не заполняется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НачисленнаяЗарплатаИВзносыБелгосстрах.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НачисленнаяЗарплатаИВзносыПоФизлицам.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокЗначений = Новый СписокЗначений;
	
	СписокЗначений.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСЗН);
		
	ОтборЭлемента.ПравоеЗначение = СписокЗначений;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не заполняется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры
// }
// 4D


&НаСервере
Процедура ЗаполнитьДополнительныеРеквизиты()
	
	НомерСтроки = 1;
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносыПоФизлицам Цикл
		
		Строка.Номер = НомерСтроки;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	МаксимальныйНомерСтроки = НомерСтроки;
	
	СписокЭлементов = Новый Массив;
	СписокЭлементов.Добавить("НачисленнаяЗарплатаИВзносыВидОперации");
	Документы.ОтражениеЗарплатыВФинансовомУчете.ЗаполнитьСпискиВыбораЭлементов(Элементы, 
		Организация, 
		ПериодРегистрации, 
		СписокЭлементов);	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеВзносов()
	
	Если Не ПоказатьВзносыПодробно Тогда
		
		Элементы.НачисленнаяЗарплатаИВзносыПФРСтраховая.Видимость                        = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыФССНесчастныеСлучаи.Видимость                 = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРНакопительная.Видимость                    = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРПоСуммарномуТарифу.Видимость               = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРДоПредельнойВеличины.Видимость             = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРСПревышения.Видимость                      = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРНаДоплатуЛетчикам.Видимость                = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРНаДоплатуШахтерам.Видимость                = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботах.Видимость = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботах.Видимость = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахБезСпецОценки.Видимость = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахСпецОценка.Видимость = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахБезСпецОценки.Видимость = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахСпецОценка.Видимость = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыФСС.Видимость                                 = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыФФОМС.Видимость                               = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыТФОМС.Видимость                               = Ложь;
		Элементы.НачисленнаяЗарплатаИВзносыВзносыВсего.Видимость                         = Истина;
		
	Иначе
		
		Элементы.НачисленнаяЗарплатаИВзносыПФРСтраховая.Видимость                        = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыФССНесчастныеСлучаи.Видимость                 = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРНакопительная.Видимость                    = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРПоСуммарномуТарифу.Видимость               = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРДоПредельнойВеличины.Видимость             = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРСПревышения.Видимость                      = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРНаДоплатуЛетчикам.Видимость                = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРНаДоплатуШахтерам.Видимость                = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботах.Видимость = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботах.Видимость = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахБезСпецОценки.Видимость = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаПодземныхИВредныхРаботахСпецОценка.Видимость = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахБезСпецОценки.Видимость = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыПФРЗаЗанятыхНаТяжелыхИПрочихРаботахСпецОценка.Видимость = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыФСС.Видимость                                 = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыФФОМС.Видимость                               = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыТФОМС.Видимость                               = Истина;
		Элементы.НачисленнаяЗарплатаИВзносыВзносыВсего.Видимость                         = Ложь;
		
		УчетСтраховыхВзносов.УстановитьВидимостьКолонокТаблицыСтраховыхВзносов(ЭтаФорма, ПериодРегистрации, "НачисленнаяЗарплатаИВзносы");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ПодразделениеПредприятия",         ПодразделениеПредприятия);
	ПараметрыОтбора.Вставить("ВидОперации",                      ВидОперации);
	ПараметрыОтбора.Вставить("СпособОтраженияЗарплатыВБухучете", СпособОтраженияЗарплатыВБухучете);
	ПараметрыОтбора.Вставить("ОблагаетсяЕНВД",                   ОблагаетсяЕНВД);
	
	Результат = Новый Структура();
	Результат.Вставить("СтруктураОтбора", ПараметрыОтбора);
	Результат.Вставить("АдресВХранилище", "");
	
	РезультатРедактированияНаСервере(Результат);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаСервере
Процедура РезультатРедактированияНаСервере(СтруктураВыбора)
	
	ДетализацияНачислений = Новый Структура("НачисленнаяЗарплатаИВзносыПоФизлицам",
		НачисленнаяЗарплатаИВзносыПоФизлицам.Выгрузить());
	
	СтруктураВыбора.АдресВХранилище = ПоместитьВоВременноеХранилище(ДетализацияНачислений);
	
КонецПроцедуры

&НаКлиенте
Функция КолонкиДляСуммирования()
		
	// 4D:ERP для Беларуси, Яна, 04.09.2017 11:04:49 
	// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
	// {
	//Возврат "ПФРСтраховая, ПФРНакопительная, ПФРПоСуммарномуТарифу, ПФРДоПредельнойВеличины, ПФРСПревышения,
	//	|ФСС, ФФОМС, ТФОМС, ПФРНаДоплатуЛетчикам, ПФРНаДоплатуШахтерам, ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,
	//	|ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах, ФССНесчастныеСлучаи,
	//	|ПФРЗаЗанятыхНаПодземныхИВредныхРаботахБезСпецОценки,
	//	|ПФРЗаЗанятыхНаПодземныхИВредныхРаботахСпецОценка,
	//	|ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахБезСпецОценки,
	//	|ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахСпецОценка";
	//Возврат "ПФРСтраховая, ФСС";
	Возврат "ФСЗН, Белгосстрах";
	// }
	// 4D	
	
КонецФункции

&НаКлиенте
Процедура РассчитатьВзносыВсего()
	
	ТекущиеДанные = Элементы.НачисленнаяЗарплатаИВзносы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КолонкиДляСуммирования = Новый Структура(КолонкиДляСуммирования());
	
	ВзносыВсего = 0;
	Для Каждого Колонка Из КолонкиДляСуммирования Цикл
		ВзносыВсего = ВзносыВсего + ТекущиеДанные[Колонка.Ключ];
	КонецЦикла;
	
	ТекущиеДанные.ВзносыВсего = ВзносыВсего;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СпособОтраженияТребуется(ВидОперации, ВзносыВсего)
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.НачисленоСдельноДоход")
		Или ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы")
		// 4D:ERP для Беларуси, АлексейЧ, 18.12.2017 13:01:00 
		// Локализовать документ "Отражение зарплаты в финансовом учете", №15826
		// {
		Или ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСЗН")
		// }
		// 4D
		Или ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС") Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

#КонецОбласти
